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
3. **Show active task**: Display the currently active task if one is set

```bash
sh .claude/commands/todo/scripts/todo_list_tasks_reverse.sh
```

Let me parse the task folders and display them in a formatted table:

| DATE | DESCRIPTION | STATUS |
| ---- | ----------- | ------ |

Now I'll check for the active task:

```bash
sh .claude/commands/todo/scripts/todo_print_active.sh
```

## Error Handling

- If the todos directory doesn't exist, an error message is displayed
- Empty directory is handled gracefully (no output)
- Active task file missing is handled as "None"
