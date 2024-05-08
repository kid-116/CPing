from typing import Any

from flask import current_app, Flask
from flask.json.provider import DefaultJSONProvider

from cping_api.models.contest import Contest


class CPingJSONProvider(DefaultJSONProvider):

    def default(self, obj: Any) -> Any:
        if isinstance(obj, Contest):
            contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']
            contest_dict = obj.to_firestore_dict()
            contest_dict[contest_fields['ID']] = obj.id_
            return contest_dict
        return super().default(obj)


def setup(app: Flask) -> None:
    app.json = CPingJSONProvider(app)
