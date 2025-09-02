---
argument-hint: [exact-folder-name]
description: Set a task as the active task
---

# Select Task

## Description

Set a specific task as the active task by writing its folder name to the ACTIVE_TASK file.

## Usage

Provide the exact folder name of the task to set as active:

```bash
/todo:select [exact-folder-name]
```

## Steps

1. **Verify folder exists**: Check that the specified task folder exists
2. **Set as active**: Write the task name to the ACTIVE_TASK file

Setting active task: $ARGUMENTS

```bash
sh .claude/commands/todo/scripts/todo_verify_folder.sh "$ARGUMENTS"
```

```bash
sh .claude/commands/todo/scripts/todo_set_active.sh "$ARGUMENTS"
```

## Error Handling

- If the folder doesn't exist, the verification step will fail
- If writing to ACTIVE_TASK file fails, an error message is displayed
- Only one task can be active at a time (overwrites previous active task)

✓ Task set as active: $ARGUMENTS
