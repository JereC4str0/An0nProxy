# An0nProxy

[![ninja-scroll-night-GIF.gif](https://i.postimg.cc/yNr3bKkh/ninja-scroll-night-GIF.gif)](https://postimg.cc/xkMdXWGq)

An0nProxy is an automatic proxy rotator designed for bug bounty hunters and security researchers. It fetches live SOCKS5 proxies from multiple sources, tests them for functionality, and configures proxychains4 to provide 100% IP hiding. If no live proxies are available, it falls back to TOR for anonymity.

## Features

- **Automatic Proxy Fetching**: Retrieves SOCKS5 proxies from reliable sources including ProxyScrape, GitHub repositories, and CDN-hosted lists.
- **Proxy Testing**: Tests up to 100 proxies concurrently with a 15-second timeout to ensure they are live and functional.
- **Proxychains4 Integration**: Automatically updates the proxychains4 configuration file with working proxies.
- **TOR Fallback**: Includes TOR as a reliable fallback when no SOCKS5 proxies are available.
- **Cron Job Support**: Can be scheduled to run periodically using cron jobs to maintain fresh proxy lists.
- **Fast and Efficient**: Uses parallel processing for quick proxy testing and configuration updates.

## Requirements

- `proxychains4` - Proxy chains tool
- `tor` - The Onion Router
- `curl` - Command line tool for transferring data
- `parallel` - GNU parallel for concurrent execution
- `sudo` - For modifying system configuration files

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/JereC4str0/An0nProxy.git
   cd An0nProxy
   ```

2. Make the script executable:
   ```bash
   chmod +x An0nproxy.sh
   ```

3. Ensure required tools are installed:
   ```bash
   sudo apt update
   sudo apt install proxychains4 tor curl parallel
   ```

4. Start TOR service:
   ```bash
   sudo systemctl start tor
   sudo systemctl enable tor
   ```

## Usage

Run the script to update proxies:
```bash
./An0nproxy.sh
```

Use proxychains4 with your tools:
```bash
proxychains4 nmap -sV target.com
proxychains4 sqlmap -u "http://target.com/vuln"
```

## Cron Job Setup

To automatically update proxies every hour, add the following to your crontab:

```bash
crontab -e
```

Add this line (adjust path as needed):
```
0 * * * * /path/to/An0nProxy/An0nproxy.sh
```

For every 30 minutes:
```
*/30 * * * * /path/to/An0nProxy/An0nproxy.sh
```

For every 15 minutes:
```
*/15 * * * * /path/to/An0nProxy/An0nproxy.sh
```

## How It Works

1. Fetches proxies from multiple sources
2. Tests proxies concurrently using parallel processing
3. Updates proxychains4 configuration with live proxies
4. Adds TOR as fallback
5. Displays final configuration

## License

This project is open source. Please use responsibly and in accordance with applicable laws.

## Disclaimer

This tool is intended for ethical security research and bug bounty programs only. Ensure you have permission before testing on any systems.
