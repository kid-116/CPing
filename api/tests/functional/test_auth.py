from http import HTTPStatus

from flask.testing import FlaskClient


def test_unauthorized_landing(client: FlaskClient) -> None:
    response = client.get('/')
    assert response.status_code == HTTPStatus.UNAUTHORIZED


def test_authorized_landing(signed_client: FlaskClient) -> None:
    response = signed_client.get('/')
    assert response.status_code == HTTPStatus.OK
