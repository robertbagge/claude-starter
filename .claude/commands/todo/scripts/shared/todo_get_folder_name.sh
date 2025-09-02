#!/bin/bash
#
# Generate folder name with ISO8601 timestamp and identifier
#
# Usage: todo_get_folder_name.sh <identifier>
#
# Arguments:
#   identifier    A short description for the task folder (1-3 words)
#
# Exit codes:
#   0       Success
#   1       General error
#   2       Invalid arguments

set -euo pipefail

readonly TIMESTAMP_FORMAT="%Y-%m-%dT%H-%M-%S"

# Validate input arguments
if [[ $# -ne 1 ]]; then
    echo "Error: Missing identifier argument" >&2
    echo "Usage: todo_get_folder_name.sh <identifier>" >&2
    exit 2
fi

readonly IDENTIFIER="$1"

# Validate identifier is not empty
if [[ -z "${IDENTIFIER}" ]]; then
    echo "Error: Identifier cannot be empty" >&2
    exit 2
fi

# Sanitize identifier (remove special characters, keep alphanumeric and hyphens)
readonly SANITIZED_IDENTIFIER=$(echo "${IDENTIFIER}" | sed 's/[^a-zA-Z0-9-]//g' | tr '[:upper:]' '[:lower:]')

# Validate sanitized identifier is not empty
if [[ -z "${SANITIZED_IDENTIFIER}" ]]; then
    echo "Error: Identifier contains no valid characters" >&2
    exit 2
fi

# Generate timestamp
if ! timestamp=$(date -u +"${TIMESTAMP_FORMAT}"); then
    echo "Error: Failed to generate timestamp" >&2
    exit 1
fi

# Output the folder name
echo "${timestamp}-${SANITIZED_IDENTIFIER}"

exit 0