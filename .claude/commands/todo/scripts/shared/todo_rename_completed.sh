#!/bin/bash
#
# Rename folder from -open to -completed
#
# Usage: todo_rename_completed.sh <folder_name>
#
# Arguments:
#   folder_name    The full folder name (including -open suffix)
#
# Exit codes:
#   0       Success
#   1       General error
#   2       Invalid arguments

set -euo pipefail

readonly TODOS_DIR="todos"

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing folder name argument" >&2
    echo "Usage: todo_rename_completed.sh <folder_name>" >&2
    exit 2
fi

readonly FOLDER_NAME="$1"

# Validate folder name is not empty
if [[ -z "${FOLDER_NAME}" ]]; then
    echo "Error: Folder name cannot be empty" >&2
    exit 2
fi

readonly SOURCE_PATH="${TODOS_DIR}/${FOLDER_NAME}"
readonly DEST_PATH="${TODOS_DIR}/${FOLDER_NAME%-open}-completed"

# Validate source folder exists
if [[ ! -d "${SOURCE_PATH}" ]]; then
    echo "Error: Source folder '${SOURCE_PATH}' does not exist" >&2
    exit 1
fi

# Rename folder from -open to -completed
if ! mv "${SOURCE_PATH}" "${DEST_PATH}"; then
    echo "Error: Failed to rename folder from '${SOURCE_PATH}' to '${DEST_PATH}'" >&2
    exit 1
fi

echo "Successfully renamed '${SOURCE_PATH}' to '${DEST_PATH}'"

exit 0