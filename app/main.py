import http
import re
import subprocess

from flask import Flask, abort, json, render_template
from flask_compress import Compress
from scapy.layers.inet import traceroute

http.server.BaseHTTPRequestHandler.version_string = lambda x: "ScapyWebUI/1.0"

app = Flask(__name__)
Compress(app)
cached_trace_routes = {}

DOMAIN_PATTERN = re.compile(r"^(?!-)([a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$")
MAX_CACHE_SIZE = 1024


@app.route("/")
def index():
    """Renders the Single Page App."""
    return render_template("index.html")


@app.route("/api/traceroute/<domain>")
def trace_route(domain):
    """Performs a trace route and returns the SVG graph."""
    if not DOMAIN_PATTERN.match(domain):
        abort(400, description="Invalid domain name.")

    # http://scapy.readthedocs.io/en/latest/usage.html#tcp-traceroute-2
    # Return the cached domain if it exists.
    if domain in cached_trace_routes:
        return cached_trace_routes[domain]

    # Run trace route.
    result, _ = traceroute([domain], dport=[80, 443], maxttl=20, retry=-2)

    # Convert to a dot graph, then render as SVG via graphviz.
    dot = result.graph(string=True)

    svg = subprocess.run(
        ["dot", "-Tsvg"],  # noqa: S603, S607
        input=dot,
        capture_output=True,
        text=True,
        check=True,
    ).stdout

    # Project simple details of the routes taken.
    routes = [(tcp.dst, ip.sprintf("%dst%:%sport%")) for tcp, ip in result]

    # Cache and return the result.
    result = json.dumps({"graph": svg, "routes": routes})

    if len(cached_trace_routes) < MAX_CACHE_SIZE:
        cached_trace_routes[domain] = result

    return result


if __name__ == "__main__":
    app.run(use_reloader=True)
