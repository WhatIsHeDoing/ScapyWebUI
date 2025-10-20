# Scapy Web UI

[![Known Vulnerabilities](https://snyk.io/test/github/WhatIsHeDoing/ScapyWebUI/badge.svg)](https://snyk.io/test/github/WhatIsHeDoing/ScapyWebUI)

![Video](demo/scapy-web-ui.gif)

## 👋 Introduction

This repository demonstrates a simple web interface calling a [Flask] API to invoke network inspection calls using the [Scapy] framework.

## 💾 Setup

Scapy has a _lot_ of optional dependencies! Those for Linux can be installed using `just install_fedora` and `just install_ubuntu`.
The Node.js and Python dependencies can be installed using `just install`.

## 🚀 Run

Open a terminal and run [Just]. The `sudo` used in the command is often required due to file and network I/O.

## 🧪 Test

Whilst the web app is running, open a separate terminal and run the integration test suite with `just test`.
This uses [Playwright] headless browser tests to verify the UI works as expected.
You can see these in a browser using `just test_interactive`.
Screenshots of successful tests are stored in the [`screenshots`](/screenshots/) directory.

[Flask]: http://flask.pocoo.org/
[Just]: https://just.systems/
[Playwright]: https://playwright.dev/
[Scapy]: http://secdev.org/projects/scapy/
