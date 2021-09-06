from flask import Flask, jsonify
from webscraping.codechef.script import main as scrape_codechef
from webscraping.codeforces.script import main as scrape_codeforces
from webscraping.atcoder.script import main as scrape_atcoder
from flask_ngrok import run_with_ngrok

app = Flask(__name__)

@app.route('/api/codechef/contests/', methods=['GET'])
def get_codechef_contests():
    contests = scrape_codechef()
    return jsonify(contests)

@app.route('/api/codeforces/contests/', methods=['GET'])
def get_codeforces_contests():
    contests = scrape_codeforces()
    return jsonify(contests)

@app.route('/api/atcoder/contests/', methods=['GET'])
def get_atcoder_contests():
    contests = scrape_atcoder()
    return jsonify(contests)

@app.route('/', methods=['GET'])
def landing():
    return "Welcome to CPing's API server"

if __name__ == '__main__':
    run_with_ngrok(app)
    app.run()