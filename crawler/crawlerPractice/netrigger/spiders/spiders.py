# -*- coding: utf-8 -*-
import logging
from urllib.parse import urlparse

import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider
from scrapy.utils.log import configure_logging


class Content(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    url = scrapy.Field()

class SpidersSpider(CrawlSpider):
    name = 'spiders'
    allowed_domains = ['*']
    start_urls = []
    def __init__(self,start_urls,selector):
        self.start_urls = start_urls
        self.selector = selector
    
    def parse(self, response):
        urlparts = urlparse(response.url)
        crawl_url=[]
        crawl_html = response.css(self.selector)[0]
        item = Content()
        url = crawl_html.css('a::attr(href)').extract_first()
        if(url.startswith('https',0,4) or url.startswith('http',0,3)):
            item['url'] = url
        else:
            item['url'] = urlparts.scheme+'://'+urlparts.netloc+url
        crawl_url.append(item)
        return crawl_url
