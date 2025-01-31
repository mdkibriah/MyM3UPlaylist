#!/bin/bash

CONFIG_FILE="channels.txt"
M3U_FILE="youtube_channels.m3u"

echo "#EXTM3U" > "$M3U_FILE"

while IFS=',' read -r CHANNEL_NAME CHANNEL_URL; do
  LIVE_URL=$(yt-dlp -g --cookies-from-browser firefox "$CHANNEL_URL" 2>/dev/null)
  if [ -n "$LIVE_URL" ]; then
    echo "#EXTINF:-1, $CHANNEL_NAME" >> "$M3U_FILE"
    echo "$LIVE_URL" >> "$M3U_FILE"
  fi
done < "$CONFIG_FILE"
echo "$(date) - script.sh ran" >> /home/ubuntu/livetv/script.log

# This is a test comment
