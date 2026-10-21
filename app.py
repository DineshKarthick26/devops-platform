from flask import Flask, jsonify
from datetime import datetime, timezone

app = Flask (__name__)

@app.route("/")
def home():
    return jsonify({
        "application": "Devops project",
        "status": "running",
        "message": "Welcome to my end-to-end devops project"
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "Healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=False)

