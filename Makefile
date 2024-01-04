run:
	sudo python3 main.py

test:
	pytest

test_interactive:
	pytest --headed

clean:
	rm screenshots/*.png

install: install_python install_nodejs

install_fedora:
	dnf install --assumeyes \
	"graphviz*" \
	chromedriver \
	gnuplot \
	ImageMagick
	nmap \
	p0f \
	python-devel \
	python-matplotlib \
	python2-pyx.x86_64 \
	tcpdump \
	texlive

install_python:
	pip3 install -r requirements.txt && playwright install

install_nodejs:
	pnpm install
