from flask import Flask, jsonify
from webscraping.codechef import main as scrape_codechef
from webscraping.codeforces import main as scrape_codeforces
from webscraping.atcoder import main as scrape_atcoder
from firestore import update_cache

app = Flask(__name__)

app.debug = True

@app.route('/api/codechef/contests/', methods=['GET'])
def get_codechef_contests():
    contests = scrape_codechef()
    update_cache(contests, 'codechef')
    return jsonify(contests)

@app.route('/api/codeforces/contests/', methods=['GET'])
def get_codeforces_contests():
    contests = scrape_codeforces()
    update_cache(contests, 'codeforces')
    return jsonify(contests)

@app.route('/api/atcoder/contests/', methods=['GET'])
def get_atcoder_contests():
    contests = scrape_atcoder()
    update_cache(contests, 'atcoder')
    return jsonify(contests)

@app.route('/', methods=['GET'])
def landing():
    return "Welcome to CPing's API server"

if __name__ == '__main__':
    app.run(debug=True)