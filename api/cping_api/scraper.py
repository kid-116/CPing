from bs4 import BeautifulSoup
from selenium.webdriver import Chrome
from selenium.webdriver import ChromeOptions


# pylint: disable=too-few-public-methods
class Scraper:

    def __init__(self) -> None:
        options = ChromeOptions()
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-gpu')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument("--window-size=1920,1080")

        self.driver = Chrome(options=options)

    def get(self, url: str) -> BeautifulSoup:
        self.driver.get(url)
        page = self.driver.page_source
        return BeautifulSoup(page, 'lxml')
