#!/bin/bash
#
# List task folders in reverse chronological order
#
# Usage: todo_list_tasks_reverse.sh
#
# Exit codes:
#   0       Success
#   1       General error

set -euo pipefail

readonly TODOS_DIR="todos"

# Check if todos directory exists
if [[ ! -d "${TODOS_DIR}" ]]; then
    echo "Error: Todos directory '${TODOS_DIR}' not found" >&2
    exit 1
fi

# List directories and sort in reverse order (newest first)
# The -r flag sorts in reverse chronological order
if ! ls -d "${TODOS_DIR}"/*/ 2>/dev/null | sort -r; then
    # No directories found is not an error condition
    exit 0
fi

exit 0