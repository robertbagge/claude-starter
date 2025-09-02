#!/bin/bash
#
# Copy template to new task folder
#
# Usage: todo_create_index.sh <folder_name>
#
# Arguments:
#   folder_name    The base name for the task folder
#
# Exit codes:
#   0       Success
#   1       General error
#   2       Invalid arguments

set -euo pipefail

readonly TEMPLATE_PATH=".claude/templates/todos/task-index-template.md"
readonly TODOS_DIR="todos"

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing folder name argument" >&2
    echo "Usage: todo_create_index.sh <folder_name>" >&2
    exit 2
fi

readonly FOLDER_NAME="$1"

# Validate folder name is not empty
if [[ -z "${FOLDER_NAME}" ]]; then
    echo "Error: Folder name cannot be empty" >&2
    exit 2
fi

readonly TASK_FOLDER="${TODOS_DIR}/${FOLDER_NAME}-open"
readonly INDEX_FILE="${TASK_FOLDER}/index.md"

# Validate template file exists
if [[ ! -f "${TEMPLATE_PATH}" ]]; then
    echo "Error: Template file '${TEMPLATE_PATH}' not found" >&2
    exit 1
fi

# Validate task folder exists
if [[ ! -d "${TASK_FOLDER}" ]]; then
    echo "Error: Task folder '${TASK_FOLDER}' does not exist" >&2
    exit 1
fi

# Copy template to task folder
if ! cp "${TEMPLATE_PATH}" "${INDEX_FILE}"; then
    echo "Error: Failed to copy template to '${INDEX_FILE}'" >&2
    exit 1
fi

exit 0