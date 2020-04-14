import asyncio
import datetime
import pprint
import re
import ssl
import time
import urllib.request
from concurrent.futures import ProcessPoolExecutor
from functools import partial
from multiprocessing import Pool
from urllib.parse import urlparse

import aiohttp
import lxml.html
import pymysql
import requests
from bs4 import BeautifulSoup

try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context


headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'}


def con_db_crawlsets(cur):
    sql = """SELECT crawlsets.id, crawlsets.url, crawlsets.selector,collections.id,collections.name
    FROM CollectionCrwalset
    INNER JOIN `collections` on CollectionCrwalset.collectionId = collections.id
    INNER JOIN `crawlsets` on CollectionCrwalset.crawlsetId = crawlsets.id
    WHERE crawlsets.deletedAt is NULL
    """
    cur.execute(sql)
    crawlsets = cur.fetchall()
    return crawlsets

async def get_links(con, cur, crawlsets):
    crawlset_id = crawlsets[0]
    url = crawlsets[1]
    selector = crawlsets[2]
    collc_id = crawlsets[3]
    collc_name = crawlsets[4]
    urlparts = urlparse(url)
    #reqs = requests.get(url,headers=headers,proxies=None,verify=False)
    async with aiohttp.ClientSession() as sess:
        async with sess.get(url, headers=headers, ssl_context=False) as res:
            html = await res.text()
    root = lxml.html.fromstring(html)
    try:
        my_titles = root.cssselect(selector)[0]
    except IndexError:
        sqlpost = "INSERT INTO `errors` (`error_keyword`, `createdAt`, `updatedAt`, `collection_id`, `crawlset_id`) VALUES (%s, %s, %s, %s, %s)"
        cur.execute(sqlpost,('selector Error',datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),collc_id,crawlset_id))
        con.commit()
    data = []
    crawl_info = {}
    if(my_titles.get('href').startswith('https',0,5) or my_titles.get('href').startswith('http',0,4)):
        crawl_info = {
            'crawlset_id': crawlset_id,
            'crawl_url': my_titles.get('href'),
            'collc_id': collc_id,
            'collc_name': collc_name
            }
    else:
        crawl_info = {
            'crawlset_id': crawlset_id,
            'crawl_url': urlparts.scheme+'://'+urlparts.netloc+my_titles.get('href'),
            'collc_id': collc_id,
            'collc_name': collc_name
            }
    crawl_url = crawl_info['crawl_url']
    sql = """SELECT COUNT(*) FROM posts WHERE url = '""" + crawl_url + """';"""
    cur.execute(sql)
    result = cur.fetchone()
    if result[0] == 0:
        data.append(crawl_info)
    else:
        sql = """SELECT * FROM posts WHERE url = '""" + crawl_url + """';"""
        cur.execute(sql)
        rows = cur.fetchall()
        convert_date = datetime.datetime.strptime(rows[0][6].split(" ")[0], "%Y-%m-%d").date()
        now = datetime.date.today()
        date_gap = now-convert_date
        if date_gap.days > 2:
            error_keyword = f"Not update:{date_gap.days}"
            sql = f"SELECT COUNT(*) FROM errors WHERE crawlset_id = {crawlset_id} AND deletedAt is NULL;"
            cur.execute(sql)
            error_result = cur.fetchone()
            if error_result[0] == 0:
                print(f"{crawl_url}은 {date_gap.days}일 전의 포스트입니다. selector를 확인하세요.")
                sql_error_insert = "INSERT IGNORE INTO `errors` (`error_keyword`, `createdAt`, `updatedAt`, `collection_id`, `crawlset_id`) VALUES (%s, %s, %s, %s, %s)"
                cur.execute(sql_error_insert,(error_keyword,datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),collc_id,crawlset_id))
                con.commit()
            else:
                sql_error_query_update = f"UPDATE errors SET error_keyword='{error_keyword}' WHERE crawlset_id = {crawlset_id}"
                print(sql_error_query_update)
                cur.execute(sql_error_query_update)
                con.commit()
    return data

async def get_content(data):
    start_time2 = time.time()
    contents = []
    for content in await data:
        url = content['crawl_url']
        urlparts = urlparse(url)
        #reqs = requests.get(url,headers=headers,proxies=None,verify=False)
        async with aiohttp.ClientSession() as sess:
            async with sess.get(url, headers=headers, ssl_context=False) as res:
                html = await res.text()
        soup = BeautifulSoup(html, 'lxml')
        content['metadata'] = {}
        content['metadata']['type'] = soup.find('meta',property=re.compile('(og:type)'))['content']
        content['metadata']['title'] = soup.find('meta',property=re.compile('(og:title)'))['content']
        content['metadata']['description'] = soup.find('meta',property=re.compile('(og:description)'))['content']
        content['metadata']['image'] = soup.find('meta',property=re.compile('(og:image)'))['content']
        content['metadata']['url'] = soup.find('meta',property=re.compile('(og:url)'))['content']
        if soup.find('meta',property=re.compile('(og:site_name)')):
            content['metadata']['site'] = soup.find('meta',property=re.compile('(og:site_name)'))['content']
        else:
            content['metadata']['site'] = urlparts.scheme+'://'+urlparts.netloc
        if soup.find('meta',property=re.compile('(og:updated_time)|(article:published_time)')):
            content['metadata']['updated_time'] = soup.find('meta',property=re.compile('(og:updated_time)|(article:published_time)'))['content']
        else:
            content['metadata']['updated_time'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        if soup.find('meta',property=re.compile('(og:locale)')):
            content['metadata']['locale'] = soup.find('meta',property=re.compile('(og:locale)'))['content']
        else:
            content['metadata']['locale'] = ''
        contents.append(content)
        runtime=round(time.time() - start_time2,2)
        print(f"{url}'s get contents: {runtime} seconds")
    return contents

async def save_content(con, cur, contents):
    for content in await contents:
        title = content['metadata']['title'][:99]
        description = content['metadata']['description'][:499]
        img = content['metadata']['image']
        url = content['metadata']['url']
        site = content['metadata']['site']
        updated_time = content['metadata']['updated_time']
        local = content['metadata']['locale']
        try:
            updated_time_format = updated_time.split("+")[0]
            if(updated_time_format[-1]=='Z'):
                updated_time = datetime.datetime.strptime(updated_time_format, '%Y-%m-%dT%H:%M:%SZ')
            else:
                updated_time = datetime.datetime.strptime(updated_time_format, '%Y-%m-%dT%H:%M:%S')
        except ValueError:
            updated_time = datetime.datetime.strptime(updated_time_format, '%Y-%m-%d %H:%M:%S')
        updated_time = updated_time.strftime("%Y-%m-%d %H:%M:%S")
        sqlpost = "INSERT IGNORE INTO `posts` (`title`, `description`, `image`, `url`, `site`, `updated_time`, `local`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        sqlcollpost = "INSERT IGNORE INTO `PostCollection` (`collectionId`, `postId`,`createdAt`,`updatedAt`) VALUES (%s, %s,%s, %s)"
        try:
            cur.execute(sqlpost,(title,description,img,url,site,updated_time,local))
            print('======== NEW POSTS ========')
            print(cur.lastrowid)
            pprint.pprint(content)
            cur.execute(sqlcollpost,(content['collc_id'],cur.lastrowid, datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
            con.commit()
            print('===========================')
        except pymysql.err.IntegrityError as err:
            print("Error: {}".format(err))

async def main():
    con = pymysql.connect(host="108.61.246.219", user="pymysql", password="Rf3)DuP?6VTn}}q[",
                       db='netrigger', charset='utf8')
    cur = con.cursor()
    crawlsets = con_db_crawlsets(cur)
    datas = [asyncio.ensure_future(get_links(con, cur,crawlset)) for crawlset in crawlsets]
    await asyncio.gather(*datas)
    for data in asyncio.as_completed(datas):
        if(len(await data)>0):
            contents = [asyncio.ensure_future(get_content(data))for data in asyncio.as_completed(datas)]
            await asyncio.gather(*contents)
            features = [asyncio.ensure_future(save_content(con, cur, contents)) for contents in asyncio.as_completed(contents)]
            await asyncio.gather(*features)
        else:
            print('새 글이 없습니다.')

if __name__=='__main__':
    start_time = time.time()
    loop = asyncio.get_event_loop()
    loop.set_default_executor(ProcessPoolExecutor(max_workers=1))
    loop.run_until_complete(main())
    runtime = round(time.time() - start_time,2)
    print(f"Total runtime: {runtime} seconds ")
