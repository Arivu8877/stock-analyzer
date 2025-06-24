#!/bin/bash

API_KEY="demo"
TICKER="IBM"

# Get today's and previous prices
DAILY_URL="https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$TICKER&apikey=$API_KEY"
DAILY_DATA=$(curl -s "$DAILY_URL")

# Use jq to get the latest two dates
DATES=($(echo "$DAILY_DATA" | jq -r '.["Time Series (Daily)"] | keys_unsorted[]' | sort -r | head -n 2))
TODAY=${DATES[0]}
YESTERDAY=${DATES[1]}

TODAY_PRICE=$(echo "$DAILY_DATA" | jq -r --arg date "$TODAY" '.["Time Series (Daily)"][$date]["4. close"]')
YESTERDAY_PRICE=$(echo "$DAILY_DATA" | jq -r --arg date "$YESTERDAY" '.["Time Series (Daily)"][$date]["4. close"]')

# Calculate last month's date
LAST_MONTH=$(date --date="$(date +%Y-%m-01) -1 day" +%Y-%m-%d)
LAST_MONTH_PRICE=$(echo "$DAILY_DATA" | jq -r --arg date "$LAST_MONTH" '.["Time Series (Daily)"][$date]["4. close"] // "N/A"')

# Calculate percentage change
PERCENT_CHANGE=$(awk "BEGIN { pc=($TODAY_PRICE - $YESTERDAY_PRICE)/$YESTERDAY_PRICE*100; printf \"%.2f\", pc }")

# Get company overview
OVERVIEW_URL="https://www.alphavantage.co/query?function=OVERVIEW&symbol=$TICKER&apikey=$API_KEY"
OVERVIEW=$(curl -s "$OVERVIEW_URL")
DESCRIPTION=$(echo "$OVERVIEW" | jq -r '.Description')

# Output
echo "Top Gainer of the Day = \"$TICKER\""
echo "Description: \"$DESCRIPTION\""
echo "Percentage Gain Today: $PERCENT_CHANGE%"
echo "Current Price: $TODAY_PRICE"
echo "Last Month's Closing Price: $LAST_MONTH_PRICE"

echo ""
echo "Top Loser of the Day = \"$TICKER\""
echo "Description: \"$DESCRIPTION\""
echo "Percentage Loss Today: $PERCENT_CHANGE%"
echo "Current Price: $TODAY_PRICE"
echo "Last Month's Closing Price: $LAST_MONTH_PRICE"
