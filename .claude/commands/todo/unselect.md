---
description: Clear the active task
---

# Unselect Task

## Description

Clear the currently active task by removing the ACTIVE_TASK file.

## Usage

```bash
/todo:unselect
```

## Steps

1. **Clear active task**: Remove the ACTIVE_TASK file if it exists

Clearing active task...

```bash
.claude/commands/todo/scripts/todo_clear_all_active.sh
```

## Error Handling

- If the ACTIVE_TASK file doesn't exist, the operation completes successfully
- No error is raised when clearing an already empty active task

✓ Active task cleared
