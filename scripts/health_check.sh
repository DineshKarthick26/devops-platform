#!/bin/bash

URL="http://localhost:5001/health"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/health_check.log"

mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$URL")
CURL_EXIT=$?

if [ "$CURL_EXIT" -eq 0 ] && [ "$HTTP_STATUS" == 200 ]; then
    echo "$TIMESTAMP - SUCCESS - Application is healthy (HTTP $HTTP_STATUS)" | tee -a "$LOG_FILE"
else
    echo "$TIMESTAMP - FAILURE - Health check failed (HTTP ${HTTP_STATUS:-000})" | tee -a "$LOG_FILE"
    exit 1
fi
