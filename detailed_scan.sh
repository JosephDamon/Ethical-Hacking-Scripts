#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# The target IP or hostname
TARGET=$1

if [ -z "$TARGET" ]; then
    echo -e "${RED}Usage: $0 <target>${NC}"
    exit 1
fi

# Perform an initial quick scan to find open ports
echo -e "${YELLOW}Scanning all ports on $TARGET...${NC}"
OPEN_PORTS=$(nmap -p- --min-rate=1000 -T4 $TARGET | grep 'open' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')

if [ -z "$OPEN_PORTS" ]; then
    echo -e "${RED}No open ports found.${NC}"
    exit 1
fi

# Run a detailed scan on the found open ports
echo -e "${GREEN}Running detailed scan on open ports: $OPEN_PORTS${NC}"
nmap -p$OPEN_PORTS -A $TARGET | perl -pe '
    s/([0-9]+)\/(tcp|udp)/\033[1;32m$&\033[0m/g; # Highlight port numbers in green
    s/open\s+(\S+)/open \033[1;34m$1\033[0m/g;    # Highlight service names in blue
'
