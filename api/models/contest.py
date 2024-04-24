import datetime

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


class FirestoreWebsiteCache(Firestore):

    def __init__(self, website: Website):
        super().__init__()

        cache_col = self.db.collection(constants.FIRESTORE_CACHE_COLLECTION)
        self.website_doc = cache_col.document(website.name.lower())
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
