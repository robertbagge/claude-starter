#!/bin/bash
#
# Print the currently active task
#
# Usage: todo_print_active.sh
#
# Exit codes:
#   0       Success
#   1       General error

set -euo pipefail

readonly ACTIVE_TASK_FILE="todos/ACTIVE_TASK"

# Print active task status
if [[ -f "${ACTIVE_TASK_FILE}" ]]; then 
    if ! active_task=$(cat "${ACTIVE_TASK_FILE}"); then
        echo "Error: Failed to read active task file" >&2
        exit 1
    fi
    echo "**Currently Active Task:** ${active_task}"
else 
    echo "**Currently Active Task:** None"
fi

exit 0