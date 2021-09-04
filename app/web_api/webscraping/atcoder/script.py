from bs4 import BeautifulSoup
from scrapingant_client import ScrapingAntClient

def parse_row(row):
    tds = row.find_all('td')
    name = tds[1].a.get_text()
    start = tds[0].get_text()
    length = tds[2].get_text()
    contest = {
        'name': name,
        'start': start,
        'length': length
    }
    return contest

# driver code for scraping
def main():
    # page url
    URL = "https://atcoder.jp/contests/"
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
    active_contests = []
    for row in soup.select('div#contest-table-action table tbody tr'):    
        active_contests.append(parse_row(row))
    contests['active-contests'] = active_contests
    # future contests
    future_contests = []
    for row in soup.select('div#contest-table-upcoming table tbody tr'):
        future_contests.append(parse_row(row))
    contests['future-contests'] = future_contests
    # print(contests)
    return contests

if __name__ == '__main__':
    main()