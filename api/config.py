from dataclasses import dataclass
from enum import Enum
import os

import dotenv

dotenv.load_dotenv()


# pylint: disable=too-few-public-methods
class Website(Enum):
    CODEFORCES = 1, 'CODEFORCES'
    ATCODER = 2, 'ATCODER'
    CODECHEF = 3, 'CODECHEF'


@dataclass
class Config:
    QUERY_PARAMS = {
        'WEBSITE_NAME': 'website',
        'CACHE_CONTESTS': 'cache',
        'FETCH_CACHED_CONTESTS': 'cached',
    }

    CONTESTS_PAGE_URL = {
        Website.CODEFORCES: 'https://codeforces.com/contests?complete=true',
        Website.ATCODER: 'https://atcoder.jp/contests',
        Website.CODECHEF: 'https://www.codechef.com/contests',
    }

    SCRAPING_CACHE_CONFIGS = {
        'TIME': 1 * 60 * 60,  # in seconds.
        'SIZE': 100,
    }

    FIRESTORE = {
        'COLLECTIONS': {
            'CACHE': {
                'NAME': os.getenv('DATABASE_NAME') or 'cache_test',
                'COLLECTIONS': {
                    'CONTEST': {
                        'NAME': 'contests',
                    }
                }
            },
        },
        'MODELS': {
            'CONTEST': {
                'FIELDS': {
                    'NAME': 'name',
                    'START_TIME': 'start',
                    'LENGTH': 'length',
                    'ID': 'id',
                }
            }
        }
    }

    HEADERS = {
        'AUTHORIZATION': 'Authorization',
    }

    API_KEY = os.getenv('API_KEY')
