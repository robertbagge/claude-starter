#!/bin/bash
# Main script for todo:create command
# Usage: create.sh [identifier]

IDENTIFIER="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# Get folder name with timestamp
FOLDER_NAME=$("$SHARED_DIR/todo_get_folder_name.sh" "$IDENTIFIER")

# Create the folder
"$SHARED_DIR/todo_create_folder.sh" "$FOLDER_NAME"

# Create the index file
"$SHARED_DIR/todo_create_index.sh" "$FOLDER_NAME"

echo "✓ Task folder created: todos/${FOLDER_NAME}/"
echo "Note: Edit the index.md file to update [todo-name] and [todo-description]"