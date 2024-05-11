from http import HTTPStatus
from typing import Callable

from bs4 import BeautifulSoup
import cachetools
import flask
from flask import current_app
from flask import Blueprint, Response

from config import Config, Website

from cping_api.cloud_messaging import Messenger
from cping_api.models.contest import Contest, FirestoreWebsiteCache
from cping_api.parser_ import atcoder, codechef, codeforces
from cping_api.scraper import Scraper

bp = Blueprint('contests', __name__, url_prefix='/api/contests')


@cachetools.cached(cache=cachetools.TTLCache(maxsize=Config.SCRAPING_CACHE_CONFIGS['SIZE'],
                                             ttl=Config.SCRAPING_CACHE_CONFIGS['TIME']))
def get_contests_util(website: Website) -> list[Contest]:
    soup = Scraper().get(website)

    parser_map: dict[Website, Callable[[BeautifulSoup], list[Contest]]] = {
        Website.CODEFORCES: codeforces.get_contests,
        Website.ATCODER: atcoder.get_contests,
        Website.CODECHEF: codechef.get_contests,
    }

    parse = parser_map[website]
    contests = parse(soup)

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
        message_changes = flask.request.args.get(
            current_app.config['QUERY_PARAMS']['MESSAGE_CHANGES']) is not None
        changes = cache.update(contests, find_changes=message_changes)
        if changes:
            Messenger.signal_contests_cache_changes(changes)

    return flask.jsonify(contests), HTTPStatus.OK
