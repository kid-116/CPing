from bs4 import BeautifulSoup
from scrapingant_client import ScrapingAntClient
from datetime import datetime, timezone, timedelta

def duration_parser(duration):
    days = duration.days
    seconds = duration.seconds
    minutes = seconds // 60
    seconds = seconds % 60
    hours = minutes // 60
    minutes = minutes % 60
    return "%02d:%02d:%02d" % (days, hours, minutes)

def parse_row(row):
    details = []
    for td in row:
        detail = td.get_text()
        details.append(detail)
    contest = {}
    contest['code'] = details[0]
    # print(contest['code'])
    contest['name'] = details[1]
    start = datetime_parser(details[2])
    end = datetime_parser(details[3])
    contest['start'] = start.strftime('%Y-%m-%d %H:%M:%Sz')
    contest['length'] = duration_parser(end - start)
    contest['venue'] = 'codechef'
    # print(contest['length'])
    return contest

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
    date = int(dt[0:2])
    month = months[dt[3:6]]
    hr = int(dt[13:15])
    min = int(dt[16:18])
    sec = int(dt[19:21])
    dt = datetime(year, month, date, hr, min, sec, tzinfo=timezone.utc)
    dt -= timedelta(hours=5, minutes=30)
    return dt

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
    contests['active-contests'] = present_contests
    # future contests
    future_contests = []
    for row in soup.select('tbody#future-contests-data tr'):
        future_contests.append(parse_row(row))
    contests['future-contests'] = future_contests
    print(contests)
    return contests

if __name__ == '__main__':
    main()