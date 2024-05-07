from typing import Any

import dateutil.parser as dateutil_parser

from config import Config


def is_contests_response_valid(body: list[dict[str, Any]]) -> bool:
    assert isinstance(body, list)
    assert len(body) > 0

    contest = body[0]

    contest_fields = Config.FIRESTORE['MODELS']['CONTEST']['FIELDS']  # type: ignore[index]

    assert contest_fields['NAME'] in contest

    assert contest_fields['START_TIME'] in contest
    assert dateutil_parser.parse(contest[contest_fields['START_TIME']])

    assert contest_fields['LENGTH'] in contest
    assert isinstance(contest[contest_fields['LENGTH']], int)

    return True
