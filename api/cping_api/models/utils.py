from firebase_admin import firestore  # type: ignore[import-untyped]


# pylint: disable=too-few-public-methods
class Firestore:

    def __init__(self) -> None:
        self.db = firestore.Client()  # pylint: disable=no-member
