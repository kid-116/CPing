from enum import Enum


# pylint: disable=too-few-public-methods
class Website(Enum):
    CODEFORCES = 1, 'CODEFORCES'
    ATCODER = 2, 'ATCODER'


WEBSITE_QUERY_PARAM = 'website'
CONTESTS_RESULT_CACHE_QUERY_PARAM = 'cache'

CONTESTS_PAGE_URL = {
    Website.CODEFORCES: 'https://codeforces.com/contests',
    Website.ATCODER: 'https://atcoder.jp/contests',
}

CONTESTS_CACHING_TIME = 3600  # in seconds.
CONTESTS_CACHING_SIZE = 100

FIRESTORE_CACHE_COLLECTION = 'cache'
FIRESTORE_WEBSITE_CACHE_LAST_UPDATED_FIELD = 'last_updated'
