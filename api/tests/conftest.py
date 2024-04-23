import os

from flask.testing import FlaskClient
import pytest

# pylint: disable=import-error
from api.app import app  # type: ignore[import-not-found]


@pytest.fixture()
def client() -> FlaskClient:
    os.environ['CONFIG_TYPE'] = 'config.TestingConfig'
    test_client = app.test_client()
    assert isinstance(test_client, FlaskClient)
    return test_client
