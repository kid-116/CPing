from models.contest import Contest
from models.contest import Website
import constants
from parser_ import atcoder, codeforces
import scraper


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
