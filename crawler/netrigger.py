#!/usr/bin/env python
import concurrent.futures
import datetime
import pprint
import re
import ssl
import time
import urllib.request
from urllib.parse import urlparse

import lxml
import metadata_parser
import pymysql
import requests
import urllib3
from bs4 import BeautifulSoup

urllib3.disable_warnings()
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'}

def get_links(crwalset_id, url, selector, collc_id, collc_name):
    # 병렬 처리 대상
    urlparts = urlparse(url)
    reqs = requests.get(url,headers=headers,proxies=None,verify=False)
    html = reqs.text
    soup = BeautifulSoup(html, 'lxml',from_encoding='utf-8')
    my_titles = soup.select(
        selector
        )[0]
    data = []
    if(my_titles.get('href').startswith('https',0,4) or my_titles.get('href').startswith('http',0,3)):
        data.append({
            'crawlset_id': crwalset_id,
            'crawl_url': my_titles.get('href'),
            'collc_id': collc_id,
            'collc_name': collc_name
            })
    else:
        data.append({
            'crawlset_id': crwalset_id,
            'crawl_url': urlparts.scheme+'://'+urlparts.netloc+my_titles.get('href'),
            'collc_id': collc_id,
            'collc_name': collc_name
            })
    return data

def con_db_crawlsets(cur):
    sql = "select cs.id, cs.url, cs.selector,coll.id,coll.name FROM crawlsets AS cs JOIN collections AS coll WHERE cs.deletedAt is NULL"
    cur.execute(sql)

    crawlsets = cur.fetchall()
    return crawlsets

def get_content(crawlsets):
    # 병렬 처리 대상
    contents = []
    for crawlet in crawlsets:
        crwalset_id = crawlet[0]
        url = crawlet[1]
        selector = crawlet[2]
        collc_id = crawlet[3]
        collc_name = crawlet[4]
        data = get_links(crwalset_id, url, selector, collc_id, collc_name)
        for content in data:
            url = content['crawl_url']
            urlparts = urlparse(url)
            reqs = requests.get(url,headers=headers,proxies=None,verify=False)
            html = reqs.text
            soup = BeautifulSoup(html, 'lxml',from_encoding='utf-8')
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
    return contents

def save_content(con, cur, data):
    for content in data:
        url = content['metadata']['url']
        sql = """SELECT COUNT(*) FROM posts WHERE url = '""" + url + """';"""
        cur.execute(sql)
        result = cur.fetchone()
        if result[0] == 0:
            title = content['metadata']['title']
            description = content['metadata']['description']
            img = content['metadata']['image']
            url = content['metadata']['url']
            site = content['metadata']['site']
            updated_time = content['metadata']['updated_time']
            local = content['metadata']['locale']
            try:
                updated_time = datetime.datetime.strptime(updated_time, '%Y-%m-%dT%H:%M:%SZ')
            except ValueError:
                updated_time = datetime.datetime.strptime(updated_time, '%Y-%m-%d %H:%M:%S')
            updated_time = updated_time.strftime("%Y-%m-%d %H:%M:%S")
            sqlpost = "INSERT INTO `posts` (`title`, `description`, `image`, `url`, `site`, `updated_time`, `local`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            sqlcollpost = "INSERT INTO `PostCollection` (`collectionId`, `postId`,`createdAt`,`updatedAt`) VALUES (%s, %s,%s, %s)"
            try:
                cur.execute(sqlpost,(title,description,img,url,site,updated_time,local))
                print('======== NEW POSTS ========')
                print(cur.lastrowid)
                cur.execute(sqlcollpost,(content['collc_id'],cur.lastrowid, datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
                con.commit()
            except pymysql.err.IntegrityError as err:
                print("Error: {}".format(err))

con = pymysql.connect(host="108.61.246.219", user="pymysql", password="Rf3)DuP?6VTn}}q[",
                       db='netrigger', charset='utf8')
cur = con.cursor()

if __name__=='__main__':
    start_time = time.time()
    crawlsets = con_db_crawlsets(cur)
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        datas = [executor.submit(get_content, crawlsets)]
        for data in concurrent.futures.as_completed(datas):
            save_content(con, cur, data.result())
            print("--- %s seconds ---" % (time.time() - start_time))
            pprint.pprint(data.result())
