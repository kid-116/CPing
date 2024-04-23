from models.contest import Website

WEBSITE_QUERY_PARAM = 'website'

CONTESTS_PAGE_URL = {
    Website.CODEFORCES: 'https://codeforces.com/contests',
    Website.ATCODER: 'https://atcoder.jp/contests',
}

CONTESTS_CACHING_TIME = 3600  # in seconds.
CONTESTS_CACHING_SIZE = 100
