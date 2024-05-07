from http import HTTPStatus

import cachetools
import flask
from flask import current_app
from flask import Blueprint, Response

from config import Config, Website
from cping_api.models.contest import Contest, FirestoreWebsiteCache
from cping_api.parser_ import atcoder, codeforces
from cping_api.scraper import Scraper

bp = Blueprint('contests', __name__, url_prefix='/api/contests')


@cachetools.cached(cache=cachetools.TTLCache(maxsize=Config.SCRAPING_CACHE_CONFIGS['SIZE'],
                                             ttl=Config.SCRAPING_CACHE_CONFIGS['TIME']))
def get_contests_util(website: Website) -> list[Contest]:
    url = current_app.config['CONTESTS_PAGE_URL'][website]
    soup = Scraper().get(url)

    contests = None
    match website:
        case Website.CODEFORCES:
            contests = codeforces.get_contests(soup)
        case Website.ATCODER:
            contests = atcoder.get_contests(soup)
        case _:
            raise NotImplementedError

    return contests


@bp.route('/', methods=['GET'])
def get_contests() -> tuple[Response | str, HTTPStatus]:
    website_arg = flask.request.args.get(current_app.config['QUERY_PARAMS']['WEBSITE_NAME'])
    try:
        if website_arg:
            website = Website[website_arg.upper()]
        else:
            raise ValueError
    except KeyError:
        error_msg = f'Invalid value for `{website_arg}` query parameter'
        return error_msg, HTTPStatus.BAD_REQUEST
    except ValueError:
        error_msg = f'No value provided for `{website_arg}` query parameter'
        return error_msg, HTTPStatus.BAD_REQUEST

    if flask.request.args.get(
            current_app.config['QUERY_PARAMS']['FETCH_CACHED_CONTESTS']) is not None:
        cache = FirestoreWebsiteCache(website)
        contests = cache.get_contests()
    else:
        contests = get_contests_util(website)

    if flask.request.args.get(current_app.config['QUERY_PARAMS']['CACHE_CONTESTS']) is not None:
        cache = FirestoreWebsiteCache(website)
        cache.update(contests)

    return flask.jsonify(contests), HTTPStatus.OK
