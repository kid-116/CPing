from __future__ import annotations
import datetime

from firebase_admin import firestore  # type: ignore[import-untyped]
from flask import current_app

from config import Website

from .utils import Firestore


# pylint: disable=too-few-public-methods
class Contest:

    def __init__(self, name: str, start: datetime.datetime, length: datetime.timedelta,
                 website: Website):
        self.name = name
        self.start = start
        self.length = length
        self.website = website

    def to_firestore_dict(self) -> dict[str, str | int | datetime.datetime]:
        contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']
        return {
            contest_fields['NAME']: self.name,
            contest_fields['START_TIME']: self.start,
            contest_fields['LENGTH']: self.length.seconds,
        }

    @staticmethod
    def from_firestore_doc(doc: firestore.DocumentSnapshot, website: Website) -> Contest:
        contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']

        doc_dict = doc.to_dict()
        name = doc_dict[contest_fields['NAME']]
        assert isinstance(name, str)
        start = doc_dict[contest_fields['START_TIME']]
        assert isinstance(start, datetime.datetime)
        length = doc_dict[contest_fields['LENGTH']]
        assert isinstance(length, int)
        return Contest(name, start, datetime.timedelta(seconds=length), website)


class FirestoreWebsiteCache(Firestore):

    def __init__(self, website: Website):
        super().__init__()

        cache_col = self.db.collection(
            current_app.config['FIRESTORE']['COLLECTIONS']['CACHE']['NAME'])
        self.website = website
        self.website_doc = cache_col.document(self.website.name.lower())
        self.contests_col = self.website_doc.collection(
            current_app.config['FIRESTORE']['COLLECTIONS']['CACHE']['COLLECTIONS']['CONTEST']
            ['NAME'])

    def update(self, contests: list[Contest]) -> None:
        # Delete old contests.
        batch = self.db.batch()
        for doc in self.contests_col.get():
            batch.delete(doc.reference)
        # Add new contests.
        for contest in contests:
            batch.set(self.contests_col.document(), contest.to_firestore_dict())
        # Update timestamp.
        batch.update(
            self.website_doc, {
                current_app.config['FIRESTORE']['COLLECTIONS']['CACHE']['FIELDS']['LAST_UPDATED']:
                    datetime.datetime.now().astimezone(datetime.timezone.utc)
            })
        batch.commit()

    def get_contests(self) -> list[Contest]:
        contests = []
        for doc in self.contests_col.stream():
            contests.append(Contest.from_firestore_doc(doc, self.website))
        return contests

    def get_last_updated(self) -> datetime.datetime:
        return self.website_doc.get().to_dict()[current_app.config['FIRESTORE']['COLLECTIONS']
                                                ['CACHE']['FIELDS']['LAST_UPDATED']].astimezone(
                                                    datetime.timezone.utc)
