BLUE="\033[0;34m"
NC="\033[0m" # No Colour
YELLOW="\033[1;33m"

echo -e "${BLUE}Running Setup${NC}"

echo -e "${YELLOW}Installing Fedora Packages...${NC}"
dnf install p0f --assumeyes
dnf install gnuplot --assumeyes
dnf install "graphviz*" --assumeyes
dnf install ImageMagick --assumeyes
dnf install nmap --assumeyes
dnf install python-matplotlib --assumeyes
dnf install PyX.x86_64 --assumeyes
dnf install tcpdump --assumeyes
dnf install texlive --assumeyes

echo -e "${YELLOW}Installing Python Packages...${NC}"
# TODO Use requirements.txt.
pip install cryptography
pip install flask
pip install gnuplot-py
pip install numpy
pip install scapy
pip install vpython

echo -e "${BLUE}Done!${NC}"
