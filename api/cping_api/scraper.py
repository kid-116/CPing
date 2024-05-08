from bs4 import BeautifulSoup
from flask import current_app
from scrapingant_client import ScrapingAntClient  # type: ignore[import-untyped]
from selenium.webdriver import Chrome
from selenium.webdriver import ChromeOptions

from config import Website


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

        self.scraping_ant_client = None
        scraping_ant_token = current_app.config['SCRAPING_ANT']['TOKEN']
        if scraping_ant_token:
            self.scraping_ant_client = ScrapingAntClient(token=scraping_ant_token)

    def get(self, website: Website) -> BeautifulSoup:
        url = current_app.config['CONTESTS_PAGE_URL'][website]

        page = None
        if self.scraping_ant_client and website in current_app.config['SCRAPING_ANT']['WEBSITES']:
            page = self.scraping_ant_client.general_request(
                url, proxy_country=current_app.config['SCRAPING_ANT']['PROXY_COUNTRY']).content
        else:
            self.driver.get(url)
            page = self.driver.page_source
        return BeautifulSoup(page, 'lxml')
