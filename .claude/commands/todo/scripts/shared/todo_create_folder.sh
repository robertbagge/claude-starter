#!/bin/bash
#
# Create task folder with '-open' suffix
#
# Usage: todo_create_folder.sh <folder_name>
#
# Arguments:
#   folder_name    The base name for the task folder
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
    echo "Usage: todo_create_folder.sh <folder_name>" >&2
    exit 2
fi

readonly FOLDER_NAME="$1"

# Validate folder name is not empty
if [[ -z "${FOLDER_NAME}" ]]; then
    echo "Error: Folder name cannot be empty" >&2
    exit 2
fi

readonly FULL_FOLDER_PATH="${TODOS_DIR}/${FOLDER_NAME}"

# Create the task folder
if ! mkdir -p "${FULL_FOLDER_PATH}"; then
    echo "Error: Failed to create folder '${FULL_FOLDER_PATH}'" >&2
    exit 1
fi

exit 0