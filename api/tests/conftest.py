from flask import Flask
from flask.testing import FlaskClient
import pytest

from config import Config
import cping_api


@pytest.fixture(scope='function')
def app() -> Flask:
    return cping_api.create_app()


@pytest.fixture(scope='function')
def client(app: Flask) -> FlaskClient:  # pylint: disable=redefined-outer-name
    test_client = app.test_client()
    assert isinstance(test_client, FlaskClient)
    return test_client


@pytest.fixture(scope='function')
def signed_client(client: FlaskClient) -> FlaskClient:  # pylint: disable=redefined-outer-name
    api_key = Config.API_KEY
    client.environ_base[f"HTTP_{Config.HEADERS['AUTHORIZATION'].upper()}"] = f'Bearer {api_key}'
    return client
