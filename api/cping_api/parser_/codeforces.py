from datetime import timedelta

from bs4 import BeautifulSoup

from config import Website

from cping_api.models.contest import Contest

from . import utils


def parse_duration(duration: str) -> timedelta:
    if len(duration.split(':')) == 2:
        duration = '00:' + duration
    days, hours, minutes = list(map(int, duration.split(':')))
    return timedelta(days=days, hours=hours, minutes=minutes)


def get_contests(soup: BeautifulSoup) -> list[Contest]:
    contests = []
    for row in soup.select('div.contestList>div.datatable table tbody tr[data-contestid]'):
        tds = row.find_all('td')

        register_anchor = tds[5].find('a')
        if not register_anchor:
            continue
        id_ = register_anchor['href'].split('/')[-1]

        name = tds[0].get_text().strip()
        if name.find('#TBA') != -1:
            continue
        newline = name.find('\n')
        if newline != -1:
            name = name[:newline]

        start = utils.parse_datetime(tds[2].get_text().strip())

        length = parse_duration(tds[3].get_text().strip())

        contests.append(Contest(id_, name, start, length, Website.CODEFORCES))

    return contests
