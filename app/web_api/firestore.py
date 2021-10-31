from firebase_admin import credentials, firestore, initialize_app
from flask.json import jsonify
from datetime import datetime, timezone

cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
cache_ref = db.collection('cache')

def update_cache(contests, site):
    # delete cache
    docs = cache_ref.document(site).collection('contests')
    cache = [contest.to_dict() for contest in docs.get()]
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
