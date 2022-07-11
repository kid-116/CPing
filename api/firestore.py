from logging import exception
from msilib.schema import Error
from firebase_admin import credentials, firestore, initialize_app
from datetime import datetime, timezone

cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
cache_ref = db.collection('cache')

def update_cache(contests, site):
    # delete cache
    try:
        docs = cache_ref.document(site).collection('contests')
        for doc in docs.get():
            docs.document(doc.id).delete()
        for type in ['future-contests', 'active-contests']:
            # update cache
            for contest in contests[type]:
                docs.document(contest['name']).set(contest)
        # updating timestamp
        cache_ref.document(site).collection('timestamp').document('last_updated').set({
            'at': datetime.now(timezone.utc)
        })
    except:
        print(exception)
