#!/bin/bash
#
# Clear active task if it matches the given folder name
#
# Usage: todo_clear_active.sh <folder_name>
#
# Arguments:
#   folder_name    The folder name to match against active task
#
# Exit codes:
#   0       Success
#   1       General error
#   2       Invalid arguments

set -euo pipefail

readonly ACTIVE_TASK_FILE="todos/ACTIVE_TASK"

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing folder name argument" >&2
    echo "Usage: todo_clear_active.sh <folder_name>" >&2
    exit 2
fi

readonly FOLDER_NAME="$1"

# Validate folder name is not empty
if [[ -z "${FOLDER_NAME}" ]]; then
    echo "Error: Folder name cannot be empty" >&2
    exit 2
fi

# Clear active task if it matches the given folder name
if [[ -f "${ACTIVE_TASK_FILE}" ]] && [[ "$(cat "${ACTIVE_TASK_FILE}")" == "${FOLDER_NAME}" ]]; then 
    if ! rm -f "${ACTIVE_TASK_FILE}"; then
        echo "Error: Failed to remove active task file" >&2
        exit 1
    fi
fi

exit 0