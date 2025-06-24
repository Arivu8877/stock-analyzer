import requests
from datetime import datetime, timedelta
import pandas as pd

API_KEY = 'CEE6143GG6X7D117'  # Alpha Vantage key
TICKERS = ['AAPL', 'IBM', 'MSFT']

def get_daily_data(symbol):
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol={symbol}&apikey={API_KEY}"
    response = requests.get(url)
    return response.json().get("Time Series (Daily)", {})

def get_overview(symbol):
    url = f"https://www.alphavantage.co/query?function=OVERVIEW&symbol={symbol}&apikey={API_KEY}"
    response = requests.get(url)
    return response.json()

def get_last_month_date():
    today = datetime.today()
    first_day_this_month = today.replace(day=1)
    last_month_last_day = first_day_this_month - timedelta(days=1)
    return last_month_last_day.strftime('%Y-%m-%d')

def main():
    stock_data = []
    last_month_date = get_last_month_date()

    for ticker in TICKERS:
        data = get_daily_data(ticker)
        if len(data) < 2:
            print(f"Skipping {ticker}, not enough data")
            continue

        dates = sorted(data.keys(), reverse=True)
        try:
           today_price = float(data[dates[0]]["4. close"])
           yesterday_price = float(data[dates[1]]["4. close"])
        except (KeyError, ValueError):
            print(f"Skipping {ticker}, price data missing")
            continue

        last_month_price = data.get(last_month_date, {}).get("4. close", "N/A")
        change = round(((today_price - yesterday_price) / yesterday_price) * 100, 2)

        stock_data.append({
            "symbol": ticker,
            "change": change,
            "today": today_price,
            "last_month": last_month_price
        })

    if not stock_data:
        print("No valid data fetched for any ticker.")
        return

    print("Fetched stock data:", stock_data)
    df = pd.DataFrame(stock_data)

    gainer = df.loc[df['change'].idxmax()]
    loser = df.loc[df['change'].idxmin()]

    for label, row in [("Top Gainer", gainer), ("Top Loser", loser)]:
        overview = get_overview(row['symbol'])
        print(f"{label} of the Day = {row['symbol']}")
        print(f"Description: {overview.get('Description', 'Not Found')}")
        print(f"Percentage Change Today: {row['change']}%")
        print(f"Current Price: {row['today']}")
        print(f"Last Month's Closing Price: {row['last_month']}")
        print()

if __name__ == "__main__":
    main()

