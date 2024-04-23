from http import HTTPStatus
from typing import Any

import flask
from flask import Flask
from flask import Response
from flask.json.provider import DefaultJSONProvider

from models.contest import Website
from models.contest import Contest
import constants
import utils


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
    contests = utils.get_contests(website)
    return flask.jsonify(contests), HTTPStatus.OK


@app.route('/', methods=['GET'])
def landing() -> tuple[str, HTTPStatus]:
    return 'Welcome to CPing\'s API server!', HTTPStatus.OK


if __name__ == '__main__':
    app.run(host='0.0.0.0')
