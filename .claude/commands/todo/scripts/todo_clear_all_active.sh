#!/bin/bash
# Clear all active task markers
# Usage: todo_clear_all_active.sh

set -euo pipefail

readonly ACTIVE_TASK_FILE="todos/ACTIVE_TASK"

# Remove active task file if it exists
if [[ -f "${ACTIVE_TASK_FILE}" ]]; then
    rm -f "${ACTIVE_TASK_FILE}"
    echo "Active task cleared"
else
    echo "No active task to clear"
fi

exit 0