FROM ubuntu:24.04
USER root

# https://stackoverflow.com/a/35976127
ARG DEBIAN_FRONTEND noninteractive
ARG USER 1000

WORKDIR /build
COPY *.py .
COPY requirements.txt .
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
    libgtk-4-dev \
    nmap \
    p0f \
    pip \
    software-properties-common \
    tcpdump

RUN pip3 install --ignore-installed blinker -r requirements.txt --break-system-packages
RUN playwright install-deps

#ENTRYPOINT ["/bin/bash"]
CMD ["python3", "main.py"]
EXPOSE 5000
