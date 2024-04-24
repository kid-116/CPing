import firebase_admin  # type: ignore[import-untyped]
from firebase_admin import firestore


# pylint: disable=too-few-public-methods
class Firestore:

    def __init__(self) -> None:

        if not firebase_admin._apps:  # pylint: disable=protected-access
            firebase_admin.initialize_app()

        self.db = firestore.Client()  # pylint: disable=no-member
