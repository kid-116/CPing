from http import HTTPStatus
import json

from flask.testing import FlaskClient
import pytest

import utils
from config import Website


@pytest.mark.parametrize('website', [e.name.lower() for e in Website])
def test_firebase_caching(signed_client: FlaskClient, website: str) -> None:
    response = signed_client.get(f'/api/contests/?website={website}&cache&message_changes')
    assert response.status_code == HTTPStatus.OK


@pytest.mark.parametrize('website', [e.name.lower() for e in Website])
def test_firebase_cache_fetch(signed_client: FlaskClient, website: str) -> None:
    response = signed_client.get(f'/api/contests/?website={website}&cached')
    assert response.status_code == HTTPStatus.OK
    data = json.loads(response.data)
    assert utils.is_contests_response_valid(data)
