#! /usr/bin/env python
"""Scapy Web UI: Single Page App."""
import time
from flask import Flask, json, render_template
from scapy.layers.inet import traceroute

app = Flask(__name__)

cached_trace_routes = {}

@app.route("/")
def index():
    """Renders the Single Page App."""
    return render_template("index.html")

@app.route("/api/traceroute/<domain>")
def trace_route(domain):
    """Performs a trace route and returns the SVG graph."""
    # http://scapy.readthedocs.io/en/latest/usage.html#tcp-traceroute-2
    # Return the cached domain if it exists.
    if domain in cached_trace_routes:
        return cached_trace_routes[domain]

    # Run trace route.
    result, _ = traceroute([domain], dport=[80,443], maxttl=20, retry=-2)

    # Convert to a dot graph.
    dot = result.graph(string=True)

    # Project simple details of the routes taken.
    routes = [(tcp.dst, ip.sprintf("%dst%:%sport%")) for tcp, ip in result]

    # Cache and return the result.
    result = json.dumps({
        "graph": dot,
        "routes": routes
    })

    cached_trace_routes[domain] = result
    return result

if __name__ == "__main__":
    app.run()
