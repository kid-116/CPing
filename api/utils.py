import cachetools

from models.contest import Contest
import constants
from constants import Website
from parser_ import atcoder, codeforces
import scraper


@cachetools.cached(
    cache=cachetools.TTLCache(maxsize=constants.CONTESTS_CACHING_SIZE,
                              ttl=constants.CONTESTS_CACHING_TIME))
def get_contests(website: Website) -> list[Contest]:
    url = constants.CONTESTS_PAGE_URL[website]
    soup = scraper.Scraper().get(url)

    contests = None
    match website:
        case Website.CODEFORCES:
            contests = codeforces.get_contests(soup)
        case Website.ATCODER:
            contests = atcoder.get_contests(soup)
        case _:
            raise NotImplementedError

    return contests
