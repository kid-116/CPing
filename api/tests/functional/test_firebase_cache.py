from http import HTTPStatus

from flask.testing import FlaskClient
import pytest

from constants import Website


@pytest.mark.parametrize('website', [e.name.lower() for e in Website])
def test_firebase_integration(signed_client: FlaskClient, website: str) -> None:
    response = signed_client.get(f'/api/contests/?website={website}&cache')
    assert response.status_code == HTTPStatus.OK
