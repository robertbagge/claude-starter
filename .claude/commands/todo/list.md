---
description: List all tasks with their status
---

# List Tasks

## Description

Display all todo tasks in reverse chronological order with their status and highlight the currently active task.

## Usage

```bash
/todo:list
```

## Steps

1. **List all tasks**: Show tasks in reverse chronological order (newest first)
2. **Format output**: Display tasks in a structured table format

```bash
sh .claude/commands/todo/scripts/list.sh
```

## Error Handling

- If the todos directory doesn't exist, an error message is displayed
- Empty directory is handled gracefully (no output)
