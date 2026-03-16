from flask import Flask, jsonify
import time
import threading

app = Flask(__name__)
leaky_storage = []

@app.route('/health')
def health():
    return jsonify(status="healthy"), 200

@app.route('/normal')
def normal():
    return jsonify(message="I am a well-behaved microservice.")

@app.route('/chaos')
def chaos():
    # 1. Simulate CPU Spike: Heavy math in a thread
    def waste_cpu():
        count = 0
        for i in range(10**7):
            count += i
    threading.Thread(target=waste_cpu).start()

    # 2. Simulate Memory Leak: Appending large strings to a global list
    global leaky_storage
    for _ in range(100):
        leaky_storage.append("X" * 1024 * 1024) # Adds 1MB per loop
    
    return jsonify(message="Chaos triggered! Memory is leaking and CPU is spiking.")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
