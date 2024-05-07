from http import HTTPStatus
import os
from typing import Any, Optional

from flask import Flask

from . import json, auth, contests


def create_app(test_config: Optional[dict[str, Any]] = None) -> Flask:
    app = Flask(__name__, instance_relative_config=True)

    if test_config is None:
        app.config.from_object('config.Config')
    else:
        app.config.from_mapping(test_config)

    # Ensure the instance folder exists.
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    json.setup(app)
    auth.setup(app)

    @app.route('/', methods=['GET'])
    def landing() -> tuple[str, HTTPStatus]:
        return 'Welcome to CPing\'s API server!', HTTPStatus.OK

    app.register_blueprint(contests.bp)

    return app
