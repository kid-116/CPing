from flask import Flask, jsonify
from webscraping.codechef.script import main as scrape_codechef

app = Flask(__name__)

@app.route('/api/codechef/contests/', methods=['GET'])
def get_codechef_contests():
    contests = scrape_codechef()
    return jsonify(contests)

@app.route('/api/codeforces/contests/', methods=['GET'])
def get_codeforces_contests():
    pass

@app.route('/api/atcoder/contests/', methods=['GET'])
def get_atcoder_contests():
    pass

if __name__ == '__main__':
    app.run()