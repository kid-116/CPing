from firebase_admin import messaging  # type: ignore[import-untyped]
from flask import current_app

from cping_api.models.contest import Contest


# pylint: disable=too-few-public-methods
class Messenger:

    @staticmethod
    def signal_contests_cache_changes(contests: list[Contest]) -> str:
        message = messaging.Message(
            data={'body': ','.join([contest.get_uid() for contest in contests])},
            topic=current_app.config['MESSAGING']['TOPICS']['CONTESTS_CACHE_CHANGE'],
        )
        message_id = messaging.send(message)
        assert isinstance(message_id, str)
        return message_id
