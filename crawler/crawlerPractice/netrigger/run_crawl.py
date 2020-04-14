# -*- coding: utf-8 -*-
from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings

selector='html>body>div#top>div:nth-of-type(2)>main#container>section>article:nth-of-type(2)>div:nth-of-type(2)>table>tbody>tr:nth-of-type(7)>td:nth-of-type(3)>a'
crwalset_url='https://gall.dcinside.com/mgallery/board/lists?id=owgenji&exception_mode=recommend'

urls = []
urls.append(crwalset_url)
def run_crawl():
    process = CrawlerProcess(get_project_settings())
    process.crawl('spiders',start_urls=urls,selector=selector)
    process.start()
if __name__ == '__main__':
    run_crawl()
