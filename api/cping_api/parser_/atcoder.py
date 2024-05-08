import datetime
from typing import Any

from bs4 import BeautifulSoup

from config import Website

from cping_api.models.contest import Contest

from . import utils


def parse_duration(duration: str) -> datetime.timedelta:
    hours, minutes = list(map(int, duration.split(':')))
    days = hours // 24
    hours = hours % 24
    return datetime.timedelta(days=days, hours=hours, minutes=minutes)


def parse_row(row: Any) -> Contest:
    tds = row.find_all('td')
    id_ = tds[1].a['href'].split('/')[-1]
    name = tds[1].a.get_text()
    # +0900 is added since the time is in JST.
    start = utils.parse_datetime(f"{tds[0].find('a')['href'][57:70]} +0900")
    length = parse_duration(tds[2].get_text())
    return Contest(id_, name, start, length, Website.ATCODER)


def get_contests(soup: BeautifulSoup) -> list[Contest]:
    contests = []
    for row in soup.select('div#contest-table-action table tbody tr'):
        contests.append(parse_row(row))
    for row in soup.select('div#contest-table-upcoming table tbody tr'):
        contests.append(parse_row(row))
    return contests
