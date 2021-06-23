from flask import Flask, jsonify
from loguru import logger

app = Flask(__name__)


@app.route("/")
def hello():
    logger.info("| << / >> endpoint was reached")
    return "Hello World!"


@app.route("/status")
def get_status():
    logger.info("| << /status >> endpoint was reached")

    response = {'result': 'OK - healthy'}
    response["user"] = "admin"
    return jsonify(response), 200


@app.route("/metrics")
def get_metrics():
    logger.info("| << /metrics >> endpoint was reached")

    response = {"status": "success"}
    response["data"] = {"UserCount": "140", "UserCountActive": "23"}
    response["user"] = "admin"
    return jsonify(response), 200


if __name__ == "__main__":
    logger.add("app.log",
               format="{time} {level} {message}",
               level="INFO",
               rotation="1 MB",
               compression="zip")

    logger.debug("| Starting Flask app")
    app.run(host='0.0.0.0', port=8080, debug=True)
    logger.debug("| Exiting Flask app")
