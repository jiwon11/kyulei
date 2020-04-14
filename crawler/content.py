import asyncio
import pprint
import re
import time
from concurrent.futures import ProcessPoolExecutor
from functools import partial
from multiprocessing import Pool

import aiohttp
import kss
import lxml
import pymysql
import requests
from bs4 import BeautifulSoup

headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'}

def con_db():
    con = pymysql.connect(host="108.61.246.219", user="pymysql", password="Rf3)DuP?6VTn}}q[",
                       db='netrigger', charset='utf8')
    cur = con.cursor()
    sql = "SELECT id,description,updated_time,url FROM posts WHERE site='벤처스퀘어' LIMIT 20;"
    cur.execute(sql)
    results = cur.fetchall()
    return results

def get_content(url):
    res = requests.get(url, headers=headers)
    html = res.text
    soup = BeautifulSoup(html, 'lxml')
    texts = soup.select(
    'p'
    )
    content=''
    for text in texts:
        text = text.get_text()
        text = text.splitlines()
        for lines in text:
            if lines != '':
                content = content+lines
    return content

def find_end_event_day(post,sentence,words,word):
    until_day_re=re.compile("[\d+]{1,2}일까지")
    month_re=re.compile("[\d+]{1,2}월")
    if until_day_re.search(word) != None:
        event = {}
        event['id'] = post['id']
        if month_re.search(words[words.index(word)-1]) != None:
            end_month = words[words.index(word)-1].replace('월','')
        else:
            updated_time_month = post['updated_time'].split(' ')[0].split('-')[1]
            end_month = f"{updated_time_month}"
        if len(end_month) == 1:
            end_month = '0'+end_month
        end_day = until_day_re.search(word).string
        end_day = re.sub('[^0-9]','',end_day)
        if len(end_day) == 1:
                end_day = '0'+end_day
        if end_day.find('∼') > 0:
            start_month = end_month
            during = end_day.split('∼')
            start_day = during[0]
            if len(start_day) == 1:
                start_day = '0'+start_day
            end_day = during[1].replace('일','')
            if len(end_day) == 1:
                end_day = '0'+end_day
            event['start_day'] = start_month+start_day
            event['end_day'] = end_month+end_day
        else:
            start_month=''
            start_day = ''
            event['start_day'] = start_month+start_day
            event['end_day'] = end_month+end_day
        return event

def find_start_event_day(post,sentence,words,word):
    updated_time_month = post['updated_time'].split(' ')[0].split('-')[1]
    updated_time_day = post['updated_time'].split(' ')[0].split('-')[2]
    since_re=re.compile("부터")
    if since_re.search(word) != None:
        event={}
        since = since_re.search(word).string
        day_re = re.compile("[\d+]{1,2}일")
        month_re = re.compile("[\d+]{1,2}월")
        day=''
        month=''
        event['id'] = post['id']
        if day_re.search(since) != None:
            since = since.replace('부터', '')
            since = since.replace('일', '')
            if len(since) == 1:
                    since = '0'+since
            day = since
            if month_re.search(words[words.index(word)-1]) != None:
                month = words[words.index(word)-1].replace('월','')
                if len(month) == 1:
                    month = '0'+month
            else:
                month = updated_time_month
            event['start_day'] = month+day
            return event

def event_format(end_events,start_events,post):
    for se in start_events:
        for ee in end_events:
            if se['id'] == ee['id']:
                ee['start_day'] = se['start_day']
            if ee['start_day']=='':
                updated_time_month = post['updated_time'].split(' ')[0].split('-')[1]
                updated_time_day = post['updated_time'].split(' ')[0].split('-')[2]
                ee['start_day'] = updated_time_month+updated_time_day
    return end_events

def main():
    results = con_db();
    end_events=[]
    start_events=[]
    for row in results:
        post={}
        post['id'] = row[0]
        post['description'] = row[1]
        post['updated_time'] = row[2]
        post['url'] = row[3]
        content = get_content(post['url'])
        post['content'] = content
        for sentence in kss.split_sentences(post['content']):
            words = re.split('\s+',sentence)
            for word in words:
                end_event = find_end_event_day(post,sentence,words,word)
                start_event = find_start_event_day(post,sentence,words,word)
                if end_event != None:
                    end_events.append(end_event)
                    post['end_event'] = end_event
                if start_event != None:
                    start_events.append(start_event)
                    post['start_event'] = start_event
        if 'end_event' in post.keys():
            pprint.pprint(post)
        events = event_format(end_events,start_events,post)
        pprint.pprint(events)

if __name__=='__main__':
    main()
