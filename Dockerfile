FROM ubuntu:24.04

# https://stackoverflow.com/a/35976127
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install apt-utils dialog && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y \
    apt-transport-https \
    apt-utils \
    build-essential \
    chromium-chromedriver \
    curl \
    libgtk-4-dev \
    nmap \
    p0f \
    software-properties-common \
    tcpdump

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

WORKDIR /build

# Install Python dependencies first for layer caching.
COPY pyproject.toml uv.lock ./
RUN uv sync
RUN uv run playwright install-deps

# Copy application code last (changes most often).
COPY app/ app/
COPY tests/ tests/

EXPOSE 5000
CMD ["uv", "run", "app/main.py"]
