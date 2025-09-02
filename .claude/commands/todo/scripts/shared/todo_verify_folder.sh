#!/bin/bash
#
# Verify folder exists
#
# Usage: todo_verify_folder.sh <folder_path>
#
# Arguments:
#   folder_path    The path to the folder to verify
#
# Exit codes:
#   0       Success (folder exists)
#   1       General error (folder does not exist)
#   2       Invalid arguments

set -euo pipefail

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing folder path argument" >&2
    echo "Usage: todo_verify_folder.sh <folder_path>" >&2
    exit 2
fi

readonly FOLDER_PATH="$1"

# Validate folder path is not empty
if [[ -z "${FOLDER_PATH}" ]]; then
    echo "Error: Folder path cannot be empty" >&2
    exit 2
fi

# Verify folder exists and is a directory
if [[ ! -d "${FOLDER_PATH}" ]]; then
    echo "Error: Folder '${FOLDER_PATH}' does not exist or is not a directory" >&2
    exit 1
fi

# List the directory to confirm it exists (original behavior)
if ! ls -d "${FOLDER_PATH}"; then
    echo "Error: Failed to list directory '${FOLDER_PATH}'" >&2
    exit 1
fi

exit 0