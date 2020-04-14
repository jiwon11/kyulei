import re
import time
from datetime import datetime
from pprint import pprint
from urllib import parse
from urllib.parse import urlparse

import feedparser
import lxml.html
import requests
from bs4 import BeautifulSoup

headers = {"User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5)\
			AppleWebKit 537.36 (KHTML, like Gecko) Chrome",
			"Accept":"text/html,application/xhtml+xml,application/xml;\
			q=0.9,imgwebp,*/*;q=0.8"}

url = 'http://cafe.daum.net/dotax/Onqu'
selector = 'html > body > iframe'
urlparse = parse.urlparse(url)

req = requests.get(url,headers = headers)
html = req.text
soup = BeautifulSoup(html, 'lxml')
for frame in soup.findAll('iframe'):
	iframeUrl = urlparse.scheme+'://'+urlparse.netloc+frame['src']
	inner_content = requests.get(iframeUrl)
	inner_content_html = inner_content.text
	soup = BeautifulSoup(inner_content_html, 'lxml')
	print(soup.findAll('meta',property=re.compile('(og:)')))
