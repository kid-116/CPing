import random
from typing import Optional

import click
from firebase_admin import messaging  # type: ignore[import-untyped]
from firebase_admin.messaging import Message, Notification  # type: ignore[import-untyped]
from flask import current_app

from config import Config, Website

from cping_api.models.contest import Contest, FirestoreWebsiteCache


# pylint: disable=too-few-public-methods
class Messenger:

    @staticmethod
    def signal_contests_cache_changes(contests: list[Contest], topic: Optional[str] = None) -> str:
        if not topic:
            topic = current_app.config['MESSAGING']['TOPICS']['CONTESTS_CACHE_CHANGE']
        body = ','.join([contest.get_uid() for contest in contests])
        message = Message(
            data={'body': body},
            topic=topic,
            notification=Notification(title='Important Update About Your Contests',
                                      body='Heads up! Some contest details have changed.'),
        )
        message_id = messaging.send(message)
        assert isinstance(message_id, str)
        return message_id


@click.command('send-test-message')
@click.option('--website',
              type=click.Choice([website.name for website in Website]),
              required=False,
              default='CODEFORCES')
@click.option('--topic',
              type=str,
              required=False,
              default=Config.MESSAGING['TOPICS']['CONTESTS_CACHE_CHANGE'])
@click.option('--num-changes', type=int, required=False, default=1)
def send_test_message_command(website: str, topic: Optional[str], num_changes: int) -> None:
    website_enum = Website[website.upper()]
    cache = FirestoreWebsiteCache(website_enum)
    contests = cache.get_contests()
    contests = random.sample(contests, min(len(contests), num_changes))
    message_id = Messenger.signal_contests_cache_changes(contests, topic)
    print(message_id)
