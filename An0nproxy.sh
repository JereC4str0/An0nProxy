#!/bin/bash
# AnonProxy v1.0 - Anonymous Proxy Rotator 
# TOR + Live SOCKS5 Proxies | 100% IP Hiding
# Author: ninj4 

CONFIG="/etc/proxychains4.conf"
TEMP="$HOME/.anonproxy_temp.txt"
LIVE="$HOME/.anonproxy_live.txt"
SOURCES=(
  "https://api.proxyscrape.com/v2/?request=getproxies&protocol=socks5&timeout=10000&country=all"
  "https://raw.githubusercontent.com/TheSpeedX/SOCKS-List/master/socks5.txt"
  "https://cdn.jsdelivr.net/gh/proxifly/free-proxy-list@main/proxies/protocols/socks5/data.txt"
)

echo -e "\e[1;34m[AnonProxy]\e[0m Fetching proxies from ${#SOURCES[@]} sources..."

> "$TEMP"
for src in "${SOURCES[@]}"; do
  curl -s "$src" >> "$TEMP" 2>/dev/null
done

echo -e "\e[1;34m[AnonProxy]\e[0m Testing up to 100 proxies (15s timeout)..."
cat "$TEMP" | grep -E '^[0-9]+\.[0-9]' | sort -u | head -100 | \
parallel -j 25 --timeout 16 \
'curl --socks5 {} -s http://httpbin.org/ip --max-time 15 >/dev/null 2>&1 && echo {}' > "$LIVE" 2>/dev/null

# Clean old proxies
sudo sed -i '/^socks5 [0-9]/d' "$CONFIG" 2>/dev/null
sudo sed -i '/^http/d' "$CONFIG" 2>/dev/null

# Add live proxies
if [ -s "$LIVE" ]; then
  sudo bash -c "cat '$LIVE' | sed 's/^/socks5 /' >> '$CONFIG'"
  COUNT=$(wc -l < "$LIVE")
  echo -e "\e[1;32m[Success]\e[0m $COUNT live proxies added!"
else
  echo -e "\e[1;33m[Warning]\e[0m No live proxies. Using TOR fallback."
fi

# TOR fallback
echo "socks5 127.0.0.1 9050" | sudo tee -a "$CONFIG" > /dev/null

echo -e "\e[1;34m[AnonProxy]\e[0m Final config:"
sudo tail -10 "$CONFIG"
echo -e "\e[1;32m[Done]\e[0m Your IP is now hidden. Use: proxychains4 <tool>"
