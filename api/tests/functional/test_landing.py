from flask.testing import FlaskClient


def test_landing(client: FlaskClient) -> None:
    response = client.get('/')
    assert response.status_code == 200
