import requests
from bs4 import BeautifulSoup
from scrapingant_client import ScrapingAntClient

# driver code for scraping
def main():
    # page url
    URL = "https://codeforces.com/contests"
    # scrapingant client
    client = ScrapingAntClient(token='08195006585c4385956bd98ca77a3f07')
    # sending req
    res = client.general_request(URL)
    # souping
    page = res.content
    soup = BeautifulSoup(page, 'lxml')
    # print(soup)
    # scraping
    contests = []
    for row in soup.select('div.contestList>div.datatable table tbody tr[data-contestid]'):
        tds = row.find_all('td')
        name = tds[0].get_text().strip()
        start = tds[2].get_text().strip()
        length = tds[3].get_text().strip()
        contest = {
            'name': name,
            'start': start,
            'length': length
        }
        contests.append(contest)
    # print(contests)
    return contests

if __name__ == '__main__':
    main()