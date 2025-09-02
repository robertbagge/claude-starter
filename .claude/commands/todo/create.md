---
argument-hint: [description, GitHub issue URL, or Notion task]
description: Create a new todo in todos/ with timestamp and folder structure
---

# Create Task

## Description

Create a new todo task with timestamp-based folder structure and index template.

## Usage

Provide a description, GitHub issue URL, or Notion task:

```bash
/todo:create [description, GitHub issue URL, or Notion task]
```

## Steps

1. **Generate folder name**: Create ISO8601 timestamp with identifier
2. **Create task folder**: Make the folder with `-open` suffix
3. **Copy template**: Initialize the task with [index.md](../../templates/todos/task-index-template.md) template
4. **Update index**: Replace placeholders with actual task information

Creating todo for: $ARGUMENTS

Generate a 1-3 word identifier (lowercase, hyphens only) from $ARGUMENTS.

```bash
sh .claude/commands/todo/scripts/todo_get_folder_name.sh "[identifier]"
```

The folder will be named: todos/[folder-name]-open

```bash
sh .claude/commands/todo/scripts/todo_create_folder.sh "[folder-name]"
```

```bash
sh .claude/commands/todo/scripts/todo_create_index.sh "[folder-name]"
```

Now I'll edit the index.md file to:

- replace [todo-name] with the the [identifier].
- replace [todo-description] with the full description from $ARGUMENTS

@todos/[folder-name]-open/index.md

## Error Handling

- If folder creation fails, an error message will be displayed
- If template copy fails, the operation will be aborted
- All operations include proper error checking and validation

✓ Task folder created: todos/[folder-name]-open/
