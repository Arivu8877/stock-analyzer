#!/bin/bash

API_KEY="CEE6143GG6X7D117"
TICKERS=("AAPL" "IBM" "MSFT")
TMP_FILE="stock_data.json"
LAST_MONTH_DATE=$(date -d "$(date +%Y-%m-01) -1 day" +%Y-%m-%d)

declare -A SYMBOL_CHANGE
declare -A SYMBOL_TODAY
declare -A SYMBOL_LAST_MONTH

for SYMBOL in "${TICKERS[@]}"; do
    echo "Fetching data for $SYMBOL..."

    # Fetch TIME_SERIES_DAILY data
    curl -s "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=${SYMBOL}&apikey=${API_KEY}" > "$TMP_FILE"
    
    # Extract date keys and sort descending
    DATES=($(jq -r '.["Time Series (Daily)"] | keys_unsorted[]' "$TMP_FILE" | sort -r))
    
    if [[ ${#DATES[@]} -lt 2 ]]; then
        echo "Not enough data for $SYMBOL"
        continue
    fi

    TODAY_DATE="${DATES[0]}"
    YESTERDAY_DATE="${DATES[1]}"
    
    TODAY_CLOSE=$(jq -r ".\"Time Series (Daily)\"[\"$TODAY_DATE\"][\"4. close\"]" "$TMP_FILE")
    YESTERDAY_CLOSE=$(jq -r ".\"Time Series (Daily)\"[\"$YESTERDAY_DATE\"][\"4. close\"]" "$TMP_FILE")
    LAST_MONTH_CLOSE=$(jq -r ".\"Time Series (Daily)\"[\"$LAST_MONTH_DATE\"][\"4. close\"] // \"N/A\"" "$TMP_FILE")

    if [[ $TODAY_CLOSE == "null" || $YESTERDAY_CLOSE == "null" ]]; then
        echo "Missing close prices for $SYMBOL"
        continue
    fi

    # Calculate percent change
    CHANGE=$(awk "BEGIN {printf \"%.2f\", (($TODAY_CLOSE - $YESTERDAY_CLOSE) / $YESTERDAY_CLOSE) * 100}")

    SYMBOL_CHANGE[$SYMBOL]=$CHANGE
    SYMBOL_TODAY[$SYMBOL]=$TODAY_CLOSE
    SYMBOL_LAST_MONTH[$SYMBOL]=$LAST_MONTH_CLOSE
done

# Find top gainer and loser
TOP_GAINER=""
TOP_LOSER=""
MAX_CHANGE=-1000
MIN_CHANGE=1000

for SYMBOL in "${!SYMBOL_CHANGE[@]}"; do
    CHANGE=${SYMBOL_CHANGE[$SYMBOL]}
    if (( $(echo "$CHANGE > $MAX_CHANGE" | bc -l) )); then
        MAX_CHANGE=$CHANGE
        TOP_GAINER=$SYMBOL
    fi
    if (( $(echo "$CHANGE < $MIN_CHANGE" | bc -l) )); then
        MIN_CHANGE=$CHANGE
        TOP_LOSER=$SYMBOL
    fi
done

print_details() {
    LABEL=$1
    SYMBOL=$2
    CHANGE=${SYMBOL_CHANGE[$SYMBOL]}
    TODAY=${SYMBOL_TODAY[$SYMBOL]}
    LAST_MONTH=${SYMBOL_LAST_MONTH[$SYMBOL]}

    echo
    echo "$LABEL of the Day: $SYMBOL"
    
    # Fetch company overview
    DESCRIPTION=$(curl -s "https://www.alphavantage.co/query?function=OVERVIEW&symbol=${SYMBOL}&apikey=${API_KEY}" | jq -r '.Description // "Description not available"')
    
    echo "Description: $DESCRIPTION"
    echo "Percentage Change Today: $CHANGE%"
    echo "Current Price: $TODAY"
    echo "Last Month's Closing Price: $LAST_MONTH"
}

# Print Results
if [[ -n $TOP_GAINER ]]; then
    print_details "Top Gainer" "$TOP_GAINER"
fi

if [[ -n $TOP_LOSER ]]; then
    print_details "Top Loser" "$TOP_LOSER"
fi

# Cleanup
rm -f "$TMP_FILE"

