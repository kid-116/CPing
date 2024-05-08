from __future__ import annotations
import datetime
from typing import Any, Optional

from firebase_admin import firestore  # type: ignore[import-untyped]
from flask import current_app

from config import Website

from .utils import Firestore


# pylint: disable=too-few-public-methods
class Contest:

    # pylint: disable=too-many-arguments
    def __init__(self, id_: str, name: str, start: datetime.datetime, length: datetime.timedelta,
                 website: Website):
        self.id_ = id_
        self.name = name
        self.start = start
        self.length = length
        self.website = website

    # pylint: enable=too-many-arguments

    def to_firestore_dict(self) -> dict[str, str | int | datetime.datetime]:
        contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']
        return {
            contest_fields['NAME']: self.name,
            contest_fields['START_TIME']: self.start,
            contest_fields['LENGTH']: int(self.length.total_seconds()),
        }

    @staticmethod
    def from_firestore_doc(doc: firestore.DocumentSnapshot, website: Website) -> Contest:
        contest_fields = current_app.config['FIRESTORE']['MODELS']['CONTEST']['FIELDS']

        id_ = doc.id
        assert isinstance(id_, str)

        doc_dict = doc.to_dict()
        name = doc_dict[contest_fields['NAME']]
        assert isinstance(name, str)
        start = doc_dict[contest_fields['START_TIME']]
        assert isinstance(start, datetime.datetime)
        length = doc_dict[contest_fields['LENGTH']]
        assert isinstance(length, int)
        return Contest(id_, name, start, datetime.timedelta(seconds=length), website)

    def __eq__(self, obj: Any) -> bool:
        if isinstance(obj, Contest):
            return self.id_ == obj.id_ and \
                self.name == obj.name and \
                self.start == obj.start and \
                self.length == obj.length and \
                self.website == obj.website
        raise NotImplementedError

    def __ne__(self, obj: Any) -> bool:
        return not self.__eq__(obj)

    def get_uid(self) -> str:
        return f'{self.website.value[1]}:{self.id_}'


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

    def update(self,
               contests: list[Contest],
               find_changes: bool = False) -> Optional[list[Contest]]:
        changes = None
        if find_changes:
            changes = self.find_changes(contests)

        batch = self.db.batch()
        for contest in contests:
            batch.set(self.contests_col.document(contest.id_), contest.to_firestore_dict())
        batch.commit()

        return changes

    def find_changes(self, contests: list[Contest]) -> list[Contest]:
        cached_contests = self.get_contests()
        cached_contest = {contest.id_: contest for contest in cached_contests}

        changes = []
        for contest in contests:
            if cached_contest.get(contest.id_):
                if cached_contest[contest.id_] != contest:
                    changes.append(contest)
        return changes

    def get_contests(self) -> list[Contest]:
        contests = []
        for doc in self.contests_col.stream():
            contests.append(Contest.from_firestore_doc(doc, self.website))
        return contests
