#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/channels.txt"
M3U_FILE="$SCRIPT_DIR/youtube_channels.m3u"

# Check if channels.txt exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE not found!"
  exit 1
fi

# Write the M3U header
echo "#EXTM3U" > "$M3U_FILE"

# Process each line in channels.txt
while IFS=',' read -r CHANNEL_NAME CHANNEL_URL; do
  # Skip empty lines or lines without both fields
  if [[ -z "$CHANNEL_NAME" || -z "$CHANNEL_URL" ]]; then
    echo "Skipping invalid entry: $CHANNEL_NAME, $CHANNEL_URL"
    continue
  fi

  # Fetch the live stream URL using yt-dlp
  LIVE_URL=$(yt-dlp -g --cookies-from-browser firefox "$CHANNEL_URL" 2>/dev/null)

  # Check if a live stream URL was found
  if [ -n "$LIVE_URL" ]; then
    echo "Adding $CHANNEL_NAME to playlist..."
    echo "#EXTINF:-1, $CHANNEL_NAME" >> "$M3U_FILE"
    echo "$LIVE_URL" >> "$M3U_FILE"
  else
    echo "Failed to fetch live URL for $CHANNEL_NAME ($CHANNEL_URL)"
  fi
done < "$CONFIG_FILE"

echo "Playlist generated successfully: $M3U_FILE"

