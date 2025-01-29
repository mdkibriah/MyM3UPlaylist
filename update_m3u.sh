#!/bin/bash

# Navigate to the repository folder
 cd /home/ubuntu/livetv || exit

# Check if there are changes
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

# Add the updated .m3u file
git add *.m3u

# Commit the changes
git commit -m "Automated update of .m3u playlist"

# Push to GitHub
git push origin main

echo "Playlist updated on GitHub!"
