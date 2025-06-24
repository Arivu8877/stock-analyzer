# Stock Analyzer - Shell Script Version

This branch contains a Bash shell script that uses the Alpha Vantage API to fetch and display stock information (Top Gainer and Loser).

## Files
- `stockscript.sh` – Bash script to fetch stock data using `curl` and `jq`
- `README.md` – This file

## Requirements
- `curl`
- `jq` (install via `sudo apt install jq` or `brew install jq`)

## How to Run
```bash
chmod +x stockscript.sh
./stockscript.sh

