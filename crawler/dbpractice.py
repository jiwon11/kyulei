from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

options = webdriver.ChromeOptions()
options.add_argument('headless')
driver = webdriver.Chrome(executable_path='/Users/jiwonjeoung/Documents/code/netrigger/crawler/chromedriver', options=options)

url = 'https://gall.dcinside.com/mgallery/board/lists?id=owgenji&exception_mode=recommend'
selector='html>body>div#top>div:nth-of-type(2)>main#container>section>article:nth-of-type(2)>div:nth-of-type(2)>table>tbody>tr:nth-of-type(7)>td:nth-of-type(3)>a'

driver.get(url)
page_results = driver.find_elements(By.CSS_SELECTOR, selector)

for item in page_results:
    print(item)
