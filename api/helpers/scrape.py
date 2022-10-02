from bs4 import BeautifulSoup
from selenium import webdriver
import os

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument('--disable-dev-shm-usage')

def scrape(url):
    driver = webdriver.Chrome(
        # executable_path='/usr/bin/chromedriver',
        chrome_options=chrome_options,
    )
    driver.get(url)
    page = driver.page_source
    soup = BeautifulSoup(page, 'lxml')
    return soup
