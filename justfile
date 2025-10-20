container := "scapy_web_ui"

# 👉 Enables commands to be selected interactively.
default:
    @just --choose

# 👟 Runs the app!
run:
    sudo python3 main.py

# 🧪 Runs unit tests.
[group("test")]
test:
    pytest

# 🧪 Runs unit tests interactively.
[group("test")]
test_interactive:
    pytest --headed

# 🧹 Removes screenshots from previous runs.
clean:
    rm screenshots/*.png

# 💾 Installs all dependencies.
install: install_python install_nodejs

# 🐧 Installs system packages on Fedora.
[group("setup")]
setup_fedora:
    dnf install --assumeyes \
        "graphviz*" \
        chromedriver \
        gnuplot \
        ImageMagick \
        nmap \
        p0f \
        python-devel \
        python-matplotlib \
        python2-pyx.x86_64 \
        tcpdump \
        texlive

# 🐧 Installs system packages on Ubuntu.
[group("setup")]
setup_ubuntu:
    sudo apt-get install -y \
        apt-transport-https \
        apt-utils \
        build-essential \
        chromium-chromedriver \
        libgtk-4-dev \
        nmap \
        p0f \
        software-properties-common \
        tcpdump

# 💾 Installs Python dependencies.
[group("install")]
install_python:
    pip3 install --ignore-installed blinker -r requirements.txt --break-system-packages
    playwright install-deps

# 💾 Installs Node.js dependencies.
[group("install")]
install_nodejs:
    pnpm install

# 🐳 Builds and runs a Docker container for portable testing.
[group("docker")]
docker: docker_build docker_run

# 🐳 Builds a Docker container.
[group("docker")]
docker_build:
    docker build -f Dockerfile -t {{container}} .

# 🐳 Runs the test Docker container API.
[group("docker")]
docker_run:
    docker run -d --name scapy-web-ui -p 5000:5000 {{container}}

# 🐳 Runs the test Docker container interactively.
[group("docker")]
docker_run_it:
    docker run -it {{container}}
