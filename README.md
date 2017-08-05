# Scapy Web UI

## Introduction
This is a simple Python web interface -- powered by [Flask][flask] -- that calls functions from the [Scapy][scapy] framework.

## Setup
**Note**: Scapy has a _lot_ of optional dependencies, so take a look through `setup.sh` before running it!

Most of the dependencies can be installed using the setup script: `sudo sh setup.sh`. The code was originally developed on [Fedora][fedora] 25 x64, with Python 2.7 and g++ pre-installed, although the commands should be adaptable to other environments.

## Run

Open a terminal a run `sudo python main.py`. You will likely need the `sudo` due to file and network I/O.

[fedora]: https://getfedora.org/
[flask]: http://flask.pocoo.org/ "Welcome | Flask (A Python Microframework)"
[scapy]: http://secdev.org/projects/scapy/
