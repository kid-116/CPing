def test_landing(client):
    response = client.get('/')
    assert response.status_code == 200
