import datetime
from http import HTTPStatus
import json

from flask import current_app, Flask
from flask.testing import FlaskClient
import pytest

import utils
from config import Website

from cping_api.models.contest import FirestoreWebsiteCache


@pytest.mark.parametrize('website', [e.name.lower() for e in Website])
def test_firebase_caching(app: Flask, signed_client: FlaskClient, website: str) -> None:
    response = signed_client.get(f'/api/contests/?website={website}&cache')
    assert response.status_code == HTTPStatus.OK
    with app.app_context():
        cache = FirestoreWebsiteCache(Website[website.upper()])
        last_updated = cache.get_last_updated()
        difference = datetime.datetime.now(tz=datetime.timezone.utc) - last_updated
        assert difference < datetime.timedelta(
            seconds=current_app.config['TESTING']['DURATION']['INSTANT'])
        assert True


@pytest.mark.parametrize('website', [e.name.lower() for e in Website])
def test_firebase_cache_fetch(signed_client: FlaskClient, website: str) -> None:
    response = signed_client.get(f'/api/contests/?website={website}&cached')
    assert response.status_code == HTTPStatus.OK
    data = json.loads(response.data)
    assert utils.is_contests_response_valid(data)
