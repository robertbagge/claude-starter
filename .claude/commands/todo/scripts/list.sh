#!/bin/bash
# Main script for todo:list command

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# List all tasks in reverse chronological order
"$SHARED_DIR/todo_list_tasks_reverse.sh"