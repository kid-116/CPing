from http import HTTPStatus
import os
from typing import Any
from typing import Callable

import dotenv
import flask
from flask import Flask
from flask import Response
from flask.json.provider import DefaultJSONProvider
from flask_http_middleware import MiddlewareManager  # type: ignore[import-untyped]
from flask_http_middleware import BaseHTTPMiddleware

from models.contest import Contest
from models.contest import FirestoreWebsiteCache
from constants import Website
import constants
import utils

dotenv.load_dotenv()


class CPingJSONProvider(DefaultJSONProvider):

    def default(self, obj: Any) -> Any:
        if isinstance(obj, Contest):
            return {
                'name': obj.name,
                'start_time': obj.start.isoformat(),
                'length': obj.length.seconds,
            }
        return super().default(self, obj)  # type: ignore[call-arg]


app = Flask(__name__)
app.json = CPingJSONProvider(app)


class AccessMiddleware(BaseHTTPMiddleware):  # type: ignore[misc]
    # pylint: disable=useless-parent-delegation
    def __init__(self) -> None:
        super().__init__()

    def dispatch(self, request: flask.Request,
                 call_next: Callable[..., flask.Response]) -> flask.Response:
        if app.debug:
            return call_next(request)
        bearer = request.headers.get(constants.AUTHORIZATION_HEADER)
        if bearer is None:
            return Response(status=HTTPStatus.UNAUTHORIZED)
        _, token = bearer.split(' ')
        if token == os.getenv(constants.API_KEY_ENV_VAR):
            return call_next(request)
        return Response(status=HTTPStatus.UNAUTHORIZED)


app.wsgi_app = MiddlewareManager(app)  # type: ignore[method-assign]
app.wsgi_app.add_middleware(AccessMiddleware)  # type: ignore[attr-defined]


@app.route('/api/contests/', methods=['GET'])
def get_contests() -> tuple[Response | str, HTTPStatus]:
    try:
        website_arg = flask.request.args.get(constants.WEBSITE_QUERY_PARAM)
        if website_arg:
            website = Website[website_arg.upper()]
        else:
            raise ValueError
    except KeyError:
        error_msg = f'Invalid value for `{constants.WEBSITE_QUERY_PARAM}` query parameter'
        return error_msg, HTTPStatus.BAD_REQUEST
    except ValueError:
        error_msg = f'No value provided for `{constants.WEBSITE_QUERY_PARAM}` query parameter'
        return error_msg, HTTPStatus.BAD_REQUEST

    if flask.request.args.get(
            constants.GET_CACHED_CONTESTS_QUERY_PARAM) is not None:
        cache = FirestoreWebsiteCache(website)
        contests = cache.get_contests()
    else:
        contests = utils.get_contests(website)

    if flask.request.args.get(
            constants.CONTESTS_RESULT_CACHE_QUERY_PARAM) is not None:
        cache = FirestoreWebsiteCache(website)
        cache.update(contests)

    return flask.jsonify(contests), HTTPStatus.OK


@app.route('/', methods=['GET'])
def landing() -> tuple[str, HTTPStatus]:
    return 'Welcome to CPing\'s API server!', HTTPStatus.OK


if __name__ == '__main__':
    app.run()
