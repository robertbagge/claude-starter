#!/bin/bash
#
# Set a task as active by writing its name to ACTIVE_TASK file
#
# Usage: todo_set_active.sh <task_name>
#
# Arguments:
#   task_name    The name of the task to set as active
#
# Exit codes:
#   0       Success
#   1       General error
#   2       Invalid arguments

set -euo pipefail

readonly ACTIVE_TASK_FILE="todos/ACTIVE_TASK"

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing task name argument" >&2
    echo "Usage: todo_set_active.sh <task_name>" >&2
    exit 2
fi

readonly TASK_NAME="$1"

# Validate task name is not empty
if [[ -z "${TASK_NAME}" ]]; then
    echo "Error: Task name cannot be empty" >&2
    exit 2
fi

# Write task name to active task file
if ! echo "${TASK_NAME}" > "${ACTIVE_TASK_FILE}"; then
    echo "Error: Failed to write task name to active task file" >&2
    exit 1
fi

echo "Task '${TASK_NAME}' set as active"

exit 0