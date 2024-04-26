import os

import dotenv
from flask.testing import FlaskClient
import pytest

from app import app
import constants

dotenv.load_dotenv()


@pytest.fixture(scope='function')
def client() -> FlaskClient:
    os.environ['CONFIG_TYPE'] = 'config.TestingConfig'
    test_client = app.test_client()
    assert isinstance(test_client, FlaskClient)
    return test_client


@pytest.fixture(scope='function')
def signed_client(client: FlaskClient) -> FlaskClient:  # pylint: disable=redefined-outer-name
    api_key = os.getenv(constants.API_KEY_ENV_VAR)
    client.environ_base[
        f'HTTP_{constants.AUTHORIZATION_HEADER.upper()}'] = f'Bearer {api_key}'
    return client
