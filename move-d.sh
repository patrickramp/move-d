#!/bin/bash

# Title: move-d.sh
# Dependencies: find, rsync
# Description: Watch for new files in a source directory and move to a remote server. 
# To run script in persistently in the background run: `nohup ./move-d.sh > /dev/null 2>&1 &`
# Version: 0.2
# License: MIT

# Configuration Variables
SOURCE_DIR="/source/directory"             # Source directory to watch
TARGET_HOST="user@host:/target/directory"  # Target host and directory
TIMESTAMP_FILE="/tmp/move-d.ts"            # Temp. file to store last sync timestamp
SSH_KEY="/path/to/ssh/key"                 # Path to your SSH private key
SSH_PORT=22                                # Custom SSH port
SLEEP_INTERVAL=10                          # Time interval between checks (in seconds)

# Create the source directory if it doesn't exist
if [ ! -d "$SOURCE_DIR" ]; then
  mkdir -p "$SOURCE_DIR"
fi

# Move to the source directory
cd "$SOURCE_DIR"

# Initialize the timestamp file with the current time if it doesn't exist
if [ ! -f "$TIMESTAMP_FILE" ]; then
  date +%s > "$TIMESTAMP_FILE"
fi

# Infinite loop to monitor the directory
while true; do

  # Get the last sync timestamp
  LAST_SYNC=$(cat "$TIMESTAMP_FILE")

  # Update the timestamp for the next iteration
  CURRENT_TIME=$(date +%s)
  echo "$CURRENT_TIME" > "$TIMESTAMP_FILE"

  # Find files modified since the last sync
  MODIFIED_FILES=$(find ./ -type f -newermt "@$LAST_SYNC")

  # Sync only if there are modified files
  if [ -n "$MODIFIED_FILES" ]; then
    find ./ -type f -newermt "@$LAST_SYNC" -print0 | \
    rsync -avz --ignore-existing --from0 --files-from=- \
      -e "ssh -i $SSH_KEY -p $SSH_PORT" \
      ./ "$TARGET_HOST"
  fi

  # Wait for the specified interval before checking again
  sleep "$SLEEP_INTERVAL"
done

