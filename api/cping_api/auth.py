from http import HTTPStatus
from typing import Callable

from flask import current_app, Flask, Request, Response
from flask_http_middleware import MiddlewareManager  # type: ignore[import-untyped]
from flask_http_middleware import BaseHTTPMiddleware


class AccessMiddleware(BaseHTTPMiddleware):  # type: ignore[misc]
    # pylint: disable=useless-parent-delegation
    def __init__(self) -> None:
        super().__init__()

    def dispatch(self, request: Request, call_next: Callable[..., Response]) -> Response:
        if current_app.debug:
            return call_next(request)
        bearer = request.headers.get(current_app.config['HEADERS']['AUTHORIZATION'])
        if bearer is None:
            return Response(status=HTTPStatus.UNAUTHORIZED)
        _, token = bearer.split(' ')
        if token == current_app.config['API_KEY']:
            return call_next(request)
        return Response(status=HTTPStatus.UNAUTHORIZED)


def setup(app: Flask) -> None:
    app.wsgi_app = MiddlewareManager(app)  # type: ignore[method-assign]
    app.wsgi_app.add_middleware(AccessMiddleware)  # type: ignore[attr-defined]
