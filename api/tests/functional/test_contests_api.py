import json
from typing import Any

import dateutil.parser as dateutil_parser
from flask.testing import FlaskClient
import pytest


def is_valid(body: list[dict[str, Any]]) -> bool:
    assert isinstance(body, list)
    assert len(body) > 0

    contest = body[0]

    assert 'name' in contest

    assert 'start_time' in contest
    assert dateutil_parser.parse(contest['start_time'])

    assert 'length' in contest
    assert isinstance(contest['length'], int)

    return True


@pytest.mark.parametrize('website', ['codeforces', 'atcoder'])
def test_codeforces_contests_api(client: FlaskClient, website: str) -> None:
    response = client.get(f'/api/contests/?website={website}')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert is_valid(data)
