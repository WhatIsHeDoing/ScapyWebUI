FROM ubuntu:24.04
USER root

# https://stackoverflow.com/a/35976127
ARG DEBIAN_FRONTEND noninteractive
ARG USER 1000

WORKDIR /build
COPY *.py .
COPY pyproject.toml .
COPY uv.lock .
COPY static/ static/
COPY screenshots/ screenshots/

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

RUN uv sync
RUN uv run playwright install-deps

#ENTRYPOINT ["/bin/bash"]
CMD ["uv", "run", "main.py"]
EXPOSE 5000
