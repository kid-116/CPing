import os

from flask.testing import FlaskClient
import pytest

from app import app


@pytest.fixture()
def client() -> FlaskClient:
    os.environ['CONFIG_TYPE'] = 'config.TestingConfig'
    test_client = app.test_client()
    assert isinstance(test_client, FlaskClient)
    return test_client
