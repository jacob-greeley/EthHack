#!/usr/bin/env python3
from flask import Flask, request

app = Flask(__name__)

@app.route("/upload", methods=["POST"])
def receive_file():
    data = request.data                    # raw bytes from the POST body
    with open("received_file", "wb") as f:
        f.write(data)
    print(f"[+] Received {len(data)} bytes, wrote to received_file")
    return "OK", 200

app.run(host="0.0.0.0", port=8080)
