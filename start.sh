#!/bin/bash
# Serves ReadingBuddy on http://localhost:8080
# Mic permission is remembered permanently on localhost (unlike file://)

PORT=8080
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting ReadingBuddy at http://localhost:$PORT"
echo "Press Ctrl+C to stop."

# Open browser after a short delay
(sleep 1 && xdg-open "http://localhost:$PORT") &

cd "$DIR"
python3 -m http.server $PORT
