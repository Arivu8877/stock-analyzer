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


## How to Run
--------------

python stockscript.py

----------------------------------------------------------------------------------------------------------------------
Note :

By default, the script uses the demo API key, which only supports IBM.

To fetch real data from multiple tickers like AAPL or MSFT, replace the demo key with your actual API key in the script:

API_KEY = 'your_actual_api_key_here'

------------------------------------------------------------------------------------------------------------------------
