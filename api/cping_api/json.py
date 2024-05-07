from typing import Any

from flask import current_app, Flask
from flask.json.provider import DefaultJSONProvider

from cping_api.models.contest import Contest


class CPingJSONProvider(DefaultJSONProvider):

    def default(self, obj: Any) -> Any:
        if isinstance(obj, Contest):
            contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']
            return {
                contest_fields['NAME']: obj.name,
                contest_fields['START_TIME']: obj.start.isoformat(),
                contest_fields['LENGTH']: obj.length.seconds,
            }
        return super().default(self, obj)  # type: ignore[call-arg]


def setup(app: Flask) -> None:
    app.json = CPingJSONProvider(app)
