container := "scapy_web_ui"

# 👉 Enables commands to be selected interactively.
default:
    @just --choose

# 👷 Runs a CI build.
ci: install lint spellcheck

# 👟 Runs the app!
run:
    sudo uv run main.py

# 🧪 Runs unit tests interactively.
[group("test")]
test_interactive:
    pytest --headed

# 🚨 Linting all files.
[group("lint")]
lint: lint_nodejs lint_python

# 🚨 Linting Node.js files.
[group("lint")]
lint_nodejs:
    pnpm lint

# 🚨 Linting Python files.
[group("lint")]
lint_python:
    uv run ruff check

# 🚨 Fixing any lint errors.
[group("lint")]
lint_fix: lint_fix_nodejs lint_fix_python

# 🚨 Fixing any Node.js lint errors.
[group("lint")]
lint_fix_nodejs:
    pnpm lint:fix

# 🚨 Fixing any Python lint errors.
[group("lint")]
lint_fix_python:
    uv run ruff format

# 📝 Spellchecks all files.
spellcheck:
    pnpm spellcheck

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
    uv sync
    uv run playwright install-deps

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
    docker build -f Dockerfile -t {{ container }} .

# 🐳 Runs the test Docker container API.
[group("docker")]
docker_run:
    docker run -d --name scapy-web-ui -p 5000:5000 {{ container }}

# 🐳 Runs the test Docker container interactively.
[group("docker")]
docker_run_it:
    docker run -it {{ container }}
