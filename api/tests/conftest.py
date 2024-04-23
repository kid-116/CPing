import os

import pytest

from api.app import app


@pytest.fixture()
def client():
    os.environ['CONFIG_TYPE'] = 'config.TestingConfig'
    return app.test_client()
