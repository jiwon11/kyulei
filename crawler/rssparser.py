import asyncio
import pprint
import re
import ssl
import time
from concurrent.futures import ProcessPoolExecutor
from datetime import datetime
from urllib.parse import urlparse

import aiohttp
import certifi
import feedparser
import lxml.html
import metadata_parser
import pymysql
from bs4 import BeautifulSoup

'''
rss = feedparser.parse();
for content in rss['entries']:
    print(content['link'])
'''
sslcontext = ssl.create_default_context(cafile=certifi.where())
headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'}

def con_db_crawlsets(cur):
    sql = """SELECT rsssets.id, rsssets.url,collections.id,collections.name
    FROM CollectionRss
    INNER JOIN `collections` on CollectionRss.collectionId = collections.id
    INNER JOIN `rsssets` on CollectionRss.rsssetId = rsssets.id
    WHERE rsssets.deletedAt is NULL
    """
    cur.execute(sql)
    crawlsets = cur.fetchall()
    return crawlsets

async def get_links(con, cur,rssset):
    start_time_gl = time.time()
    rssset_id = rssset[0]
    url = rssset[1]
    collc_id = rssset[2]
    collc_name = rssset[3]
    rss = feedparser.parse(url)
    #content = rss['entries'][0]
    data = []
    for content in rss['entries']:
        crawl_info = {}
        crawl_info = {
            'crawlset_id': rssset_id,
            'item': content,
            'rss' : rss,
            'collc_id': collc_id,
            'collc_name': collc_name
            }
        crawl_url = content.link
        sql = """SELECT COUNT(*) FROM posts WHERE url = '""" + crawl_url + """';"""
        cur.execute(sql)
        result = cur.fetchone()
        if result[0] == 0:
            data.append(crawl_info)
            runtime=round(time.time() - start_time_gl,2)
            print(f"{crawl_url}'s get links: {runtime} seconds")
    return data

async def get_content(data):
    start_time2 = time.time()
    contents = []
    for content in await data:
        item = content['item']
        rss = content['rss']
        content['metadata'] = {}
        if('publisher_detail' in rss.feed):
            content['metadata']['site'] = rss.feed.publisher_detail.name
        else:
            urlparts = urlparse(item.link)
            site = urlparts.netloc.split('.')[1]
            content['metadata']['site'] = site
        content['metadata']['title'] = item.title
        content['metadata']['url'] = item.link
        content['metadata']['updated_time'] = datetime(*item.updated_parsed[:6]).isoformat()
        soup = BeautifulSoup(item.summary, 'lxml')
        if(soup.find('img')):
            content['metadata']['image'] = soup.find('img')['src']
        else:
            content['metadata']['image'] = ''
        description = ''
        for string in soup.find_all(text=True):
            string.replace("\n","")
            string.replace(" ","")
            if(string !='' or string !='\n'):
                description = description+' '+string
        content['metadata']['description'] = description
        if('language' in rss.feed):
            content['metadata']['locale'] = rss.feed.language
        else:
            content['metadata']['locale'] = ''
        runtime=round(time.time() - start_time2,2)
        contents.append(content)
        print(f"{item.link}'s get contents: {runtime} seconds")
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
            updated_time = datetime.strptime(updated_time, '%Y-%m-%dT%H:%M:%S')
        except ValueError:
            updated_time = datetime.strptime(updated_time, '%Y-%m-%d %H:%M:%S')
        updated_time = updated_time.strftime("%Y-%m-%d %H:%M:%S")
        sqlpost = "INSERT IGNORE INTO `posts` (`title`, `description`, `image`, `url`, `site`, `updated_time`, `local`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        sqlcollpost = "INSERT INTO `PostCollection` (`collectionId`, `postId`,`createdAt`,`updatedAt`) VALUES (%s, %s,%s, %s)"
        try:
            cur.execute(sqlpost,(title,description,img,url,site,updated_time,local))
            print('======== NEW POSTS ========')
            print(cur.lastrowid)
            pprint.pprint(content['metadata'])
            cur.execute(sqlcollpost,(content['collc_id'],cur.lastrowid, datetime.now().strftime("%Y-%m-%d %H:%M:%S"), datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
            con.commit()
            print('===========================')
        except pymysql.err.IntegrityError as err:
            print("Error: {}".format(err))

async def main():
    con = pymysql.connect(host="108.61.246.219", user="pymysql", password="Rf3)DuP?6VTn}}q[",
                       db='netrigger', charset='utf8')
    cur = con.cursor()
    rsssets = con_db_crawlsets(cur)
    datas = [asyncio.ensure_future(get_links(con, cur,rssset)) for rssset in rsssets]
    await asyncio.gather(*datas)
    for data in asyncio.as_completed(datas):
            if(len(await data)>0):
                contents = [asyncio.ensure_future(get_content(data))for data in asyncio.as_completed(datas)]
                await asyncio.gather(*contents)
                features = [asyncio.ensure_future(save_content(con, cur, contents)) for contents in asyncio.as_completed(contents)]
                await asyncio.gather(*features)
            else:
                print("이미 있는 포스트입니다.")

if __name__=='__main__':
    start_time = time.time()
    loop = asyncio.get_event_loop()
    loop.set_default_executor(ProcessPoolExecutor(max_workers=3))
    loop.run_until_complete(main())
    runtime = round(time.time() - start_time,2)
    print(f"Total runtime: {runtime} seconds ")
