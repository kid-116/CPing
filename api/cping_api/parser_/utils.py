import datetime
from datetime import timezone
import re

from dateutil import parser as dateutil_parser


def parse_datetime(datetime_str: str) -> datetime.datetime:
    datetime_str = datetime_str.replace('UTC', ' ')

    match = re.search(r'[+|-]([0-9]+\.[0-9]+)', datetime_str)
    if match:
        decimal_timezone = match.group(1)
        hour, minute = decimal_timezone.split('.')
        hour = int(hour)
        if len(minute) == 1:
            minute = minute + '0'
        minute = (int(minute) * 60) // 100
        datetime_str = datetime_str.replace(decimal_timezone, f'{hour:02d}:{minute:02d}')

    dt = dateutil_parser.parse(datetime_str).astimezone(timezone.utc)
    assert isinstance(dt, datetime.datetime)
    return dt
