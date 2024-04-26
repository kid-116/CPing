from __future__ import annotations
import datetime

from firebase_admin import firestore  # type: ignore[import-untyped]

import constants
from constants import Website
from .utils import Firestore


# pylint: disable=too-few-public-methods
class Contest:

    def __init__(self, name: str, start: datetime.datetime,
                 length: datetime.timedelta, website: Website):
        self.name = name
        self.start = start
        self.length = length
        self.website = website

    def to_firestore_dict(self) -> dict[str, str | int | datetime.datetime]:
        return {
            'name': self.name,
            'start': self.start,
            'length': self.length.seconds,
        }

    @staticmethod
    def from_firestore_doc(doc: firestore.DocumentSnapshot,
                           website: Website) -> Contest:
        doc_dict = doc.to_dict()
        name = doc_dict['name']
        assert isinstance(name, str)
        start = doc_dict['start']
        assert isinstance(start, datetime.datetime)
        length = doc_dict['length']
        assert isinstance(length, int)
        return Contest(name, start, datetime.timedelta(seconds=length), website)


class FirestoreWebsiteCache(Firestore):

    def __init__(self, website: Website):
        super().__init__()

        cache_col = self.db.collection(constants.FIRESTORE_CACHE_COLLECTION)
        self.website = website
        self.website_doc = cache_col.document(self.website.name.lower())
        self.contests_col = self.website_doc.collection('contests')

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
                constants.FIRESTORE_WEBSITE_CACHE_LAST_UPDATED_FIELD:
                    datetime.datetime.now().astimezone(datetime.timezone.utc)
            })
        batch.commit()

    def get_contests(self) -> list[Contest]:
        contests = []
        for doc in self.contests_col.stream():
            contests.append(Contest.from_firestore_doc(doc, self.website))
        return contests
