#! /usr/bin/env python
"""Scapy Web UI: Single Page App."""
from flask import Flask,render_template
from scapy.layers.inet import traceroute

app = Flask(__name__)

@app.route("/")
def index():
    """Renders the Single Page App."""
    return render_template("index.html")

@app.route("/traceroute/<domain>")
def trace_route(domain):
    """Performs a trace route and returns the SVG graph."""
    # http://scapy.readthedocs.io/en/latest/usage.html#tcp-traceroute-2
    result, _ = traceroute([domain], dport=[80,443], maxttl=20, retry=-2)

    # TODO Create the graph in memory.
    filename = "/tmp/graph.svg"
    output = "> " + filename
    result.graph(target=output)

    # TODO Return JSON object with individual IPs.
    return open(filename).read()

if __name__ == "__main__":
    app.run()
