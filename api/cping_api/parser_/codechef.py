import datetime
import re
from typing import Any

from bs4 import BeautifulSoup

from config import Website

from cping_api.models.contest import Contest

from . import utils


def parse_duration(td: Any) -> datetime.timedelta:
    days, hours, minutes = 0, 0, 0

    for p in td.find_all('p'):
        text = p.get_text()

        min_match = re.search('^([0-9]+) Min$', text)
        if min_match:
            minutes = int(min_match.group(1))

        hr_match = re.search('^([0-9]+) Hrs$', text)
        if hr_match:
            hours = int(hr_match.group(1))

        day_match = re.search('^([0-9]+) Days$', text)
        if day_match:
            days = int(day_match.group(1))

    return datetime.timedelta(days=days, hours=hours, minutes=minutes)


def parse_row(row: Any) -> Contest:
    tds = row.find_all('td')

    id_ = tds[0].p.get_text()

    name = tds[1].find_all('div')[1].get_text()

    date, time = tds[2].find_all('p')
    # The timezone annotation (+0000) is hard-coded because in the production environment,
    # the proxy is based in UTC timezone.
    start = utils.parse_datetime(f'{date.get_text()} {time.get_text()} +0000')

    length = parse_duration(tds[3])

    return Contest(id_, name, start, length, Website.CODECHEF)


def extract_rows(table: Any) -> list[Any]:
    rows = []
    for row in table:
        if len(row.find_all('td')) == 6:
            rows.append(row)
    return rows


def get_contests(soup: BeautifulSoup) -> list[Contest]:
    contests = []
    tables = soup.select('tbody.MuiTableBody-root')
    for row in extract_rows(tables[0]):
        contests.append(parse_row(row))
    for row in extract_rows(tables[1]):
        contests.append(parse_row(row))
    return contests
