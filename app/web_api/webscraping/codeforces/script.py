import requests
from bs4 import BeautifulSoup
from scrapingant_client import ScrapingAntClient
from datetime import date, datetime, timezone

def datetime_parser(dt):
    months = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12
    }
    year = int(dt[7:11])
    date = int(dt[4:6])
    month = months[dt[0:3]]
    hr = int(dt[12:14])
    min = int(dt[15:17])
    dt = datetime(year, month, date, hr, min, tzinfo=timezone.utc)
    return dt

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
    contests = {}
    contests['future-contests'] = []
    contests['active-contests'] = []
    now = datetime.utcnow().replace(tzinfo=timezone.utc)
    # print(now)
    for row in soup.select('div.contestList>div.datatable table tbody tr[data-contestid]'):
        tds = row.find_all('td')
        name = tds[0].get_text().strip()
        start = datetime_parser(tds[2].get_text().strip())
        length = tds[3].get_text().strip()
        contest = {
            'name': name,
            'start': start,
            'length': length
        }
        if(start > now):
            contests['future-contests'].append(contest)
        else:
            contests['active-contests'].append(contest)
    # print(contests)
    return contests

if __name__ == '__main__':
    main()