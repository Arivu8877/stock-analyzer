import requests
from datetime import datetime, timedelta

API_KEY = 'demo'  # Alpha Vantage demo key
TICKER = 'IBM'    # Only demo stock supported

def get_daily_data(symbol):
    url = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol={symbol}&apikey={API_KEY}"
    response = requests.get(url)
    return response.json().get("Time Series (Daily)", {})

def get_overview(symbol):
    url = f"https://www.alphavantage.co/query?function=OVERVIEW&symbol={symbol}&apikey={API_KEY}"
    response = requests.get(url)
    return response.json()

def get_last_month_close(data):
    today = datetime.today()
    first_day_this_month = today.replace(day=1)
    last_day_last_month = first_day_this_month - timedelta(days=1)
    return data.get(last_day_last_month.strftime('%Y-%m-%d'), {}).get("4. close", "N/A")

def get_percent_change(today_price, yesterday_price):
    try:
        return round(((today_price - yesterday_price) / yesterday_price) * 100, 2)
    except ZeroDivisionError:
        return 0

def main():
    daily_data = get_daily_data(TICKER)
    if not daily_data or len(daily_data) < 2:
        print(f"No data returned for {TICKER}")
        return

    dates = sorted(daily_data.keys(), reverse=True)
    today_price = float(daily_data[dates[0]]["4. close"])
    yesterday_price = float(daily_data[dates[1]]["4. close"])
    last_month_price = get_last_month_close(daily_data)
    change_percent = get_percent_change(today_price, yesterday_price)
    overview = get_overview(TICKER)

    print(f"Top Gainer of the Day = \"{TICKER}\"")
    print(f"Description: \"{overview.get('Description', 'Description not available')}\"")
    print(f"Percentage Gain Today: {change_percent}%")
    print(f"Current Price: {today_price}")
    print(f"Last Month's Closing Price: {last_month_price}")
    print("\n")
    print(f"Top Loser of the Day = \"{TICKER}\"")
    print(f"Description: \"{overview.get('Description', 'Description not available')}\"")
    print(f"Percentage Loss Today: {change_percent}%")
    print(f"Current Price: {today_price}")
    print(f"Last Month's Closing Price: {last_month_price}")

if __name__ == "__main__":
    main()

