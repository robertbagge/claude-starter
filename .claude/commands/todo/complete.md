---
argument-hint: [exact-folder-name]
description: Mark a task as completed
---

# Complete Task

## Description

Mark a task as completed by renaming the folder from `-open` to `-completed` suffix and clearing it from the active task file.

## Usage

To complete a task, provide the exact folder name as an argument:

```bash
/todo:complete [exact-folder-name]
```

## Steps

1. **Verify folder exists**: Check that the specified task folder exists
2. **Rename folder**: Change the folder suffix from `-open` to `-completed`
3. **Clear active task**: Remove the task from ACTIVE_TASK file if it's currently active

Completing task: $ARGUMENTS

```bash
sh .claude/commands/todo/scripts/todo_verify_folder.sh "$ARGUMENTS"
```

Let me rename the folder from -open to -completed suffix.

```bash
sh .claude/commands/todo/scripts/todo_rename_completed.sh "$ARGUMENTS"
```

```bash
sh .claude/commands/todo/scripts/todo_clear_active.sh "$ARGUMENTS"
```

## Error Handling

- If the folder doesn't exist, the verification step will fail
- If the rename operation fails, an error message will be displayed
- Script execution stops on any error condition

✓ Task completed: $ARGUMENTS
