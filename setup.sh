BLUE="\033[0;34m"
NC="\033[0m" # No Colour
YELLOW="\033[1;33m"

echo -e "${BLUE}Running Setup${NC}"

echo -e "${YELLOW}Installing Fedora Packages...${NC}"

dnf install --assumeyes \
    chromedriver \
    p0f \
    gnuplot \
    "graphviz*" \
    ImageMagick
    nmap \
    p0f \
    python-devel \
    python-matplotlib \
    python2-pyx.x86_64 \
    tcpdump \
    texlive

echo -e "${YELLOW}Installing Python Packages...${NC}"
pip install -r requirements.txt -user

echo -e "${YELLOW}Installing NPM Packages...${NC}"
npm install

echo -e "${BLUE}Done!${NC}"
