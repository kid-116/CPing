from logging import exception
from firebase_admin import credentials, firestore, initialize_app
from datetime import datetime, timezone
import os

cred = credentials.Certificate({
  'type': os.getenv('type'),
  'project_id': os.getenv('project_id'),
  'private_key_id': os.getenv('private_key_id'),
  'private_key': os.getenv('private_key'),
  'client_email': os.getenv('client_email'),
  'client_id': os.getenv('client_id'),
  'auth_uri': os.getenv('auth_uri'),
  'token_uri': os.getenv('token_uri'),
  'auth_provider_x509_cert_url': os.getenv('auth_provider_x509_cert_url'),
  'client_x509_cert_url': os.getenv('client_x509_cert_url')
})
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
