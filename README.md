# Stock Analyzer Script - Alpha Vantage API

This script fetches stock market data using the [Alpha Vantage API](https://www.alphavantage.co/documentation/), identifies the top gainer and loser of the day from a sample list of stock symbols, and displays key information such as:

- Company Description
- Today's % Change
- Current Price
- Last Month’s Closing Price

---

## 📦 Features

- Uses free Alpha Vantage API endpoints
- Calculates % change between today's and yesterday's price
- Retrieves company descriptions
- Displays last month's closing price

---

## 🧰 Requirements

- Python 3.7 or above
- `requests` library
- `pandas` library

Install dependencies using:

```bash
pip install -r requirements.txt

