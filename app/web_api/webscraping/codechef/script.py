import requests
from bs4 import BeautifulSoup
from scrapingant_client import ScrapingAntClient

def parse_row(row):
    details = []
    for td in row:
        detail = td.get_text()
        details.append(detail)
    contest = {}
    contest['code'] = details[0]
    contest['name'] = details[1]
    contest['start'] = details[2]
    contest['end'] = details[3]
    return contest

# driver code for scraping
def main():
    # page url
    URL = "https://www.codechef.com/contests/?itm_medium=navmenu&itm_campaign=allcontests#future-contests"
    # scrapingant client
    client = ScrapingAntClient(token='08195006585c4385956bd98ca77a3f07')
    # sending req
    res = client.general_request(URL)
    # souping
    page = res.content
    soup = BeautifulSoup(page, 'lxml')
    # print(soup)
    # scraping
    contests = {}
    # present contests
    present_contests = []
    for row in soup.select('tbody#present-contests-data tr'):    
        present_contests.append(parse_row(row))
    contests['present-contests'] = present_contests
    # future contests
    future_contests = []
    for row in soup.select('tbody#future-contests-data tr'):
        future_contests.append(parse_row(row))
    contests['future-contests'] = future_contests
    return contests

if __name__ == '__main__':
    main()