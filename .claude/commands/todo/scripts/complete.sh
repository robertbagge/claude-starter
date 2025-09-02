#!/bin/bash
# Main script for todo:complete command
# Usage: complete.sh [folder-name]

FOLDER_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# Rename the folder from -open to -completed
"$SHARED_DIR/todo_rename_completed.sh" "$FOLDER_NAME"