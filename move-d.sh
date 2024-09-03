#!/bin/bash

# Title: move-d.sh
# Description: Move new files from current directory to a remote server.
# Usage: (From inside the directory to be synced) run: ./move-d.sh 
# Dependencies: find, rsync
# Version: 0.1
# License: MIT

# Configuration Variables
TARGET_HOST="user@host:/target/directory"  # Target host and directory
TIMESTAMP_FILE="/tmp/move-d.ts"            # Temp. file to store last sync timestamp
SSH_KEY="/path/to/ssh/key"                 # Path to your SSH private key
SSH_PORT=22                                # Custom SSH port
SLEEP_INTERVAL=10                          # Time interval between checks (in seconds)


# Initialize the timestamp file with the current time if it doesn't exist
if [ ! -f "$TIMESTAMP_FILE" ]; then
  date +%s > "$TIMESTAMP_FILE"
fi

# Infinite loop to monitor the directory
while true; do

  # Get the last sync timestamp
  LAST_SYNC=$(cat "$TIMESTAMP_FILE")

  # Find files modified since the last sync
  MODIFIED_FILES=$(find ./ -type f -newermt "@$LAST_SYNC")

  # Update the timestamp for the next iteration
  CURRENT_TIME=$(date +%s)
  echo "$CURRENT_TIME" > "$TIMESTAMP_FILE"

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

