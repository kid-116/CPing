import datetime
from enum import Enum


class Website(Enum):
    CODEFORCES = 1, 'CODEFORCES'
    ATCODER = 2, 'ATCODER'


# pylint: disable=too-few-public-methods
class Contest:

    def __init__(self, name: str, start: datetime.datetime,
                 length: datetime.timedelta, website: Website):
        self.name = name
        self.start = start
        self.length = length
        self.website = website
