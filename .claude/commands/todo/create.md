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

1. **Generate folder name**: Create identifier from description
2. **Create task folder**: Make the folder
3. **Copy template**: Initialize the task with
   [index.md](../../templates/index.template.md) template
4. **Update index**: Replace placeholders with actual task information

Creating todo for: $ARGUMENTS

Generate a 2-4 word identifier (lowercase, hyphens only) from $ARGUMENTS.

```bash
sh .claude/commands/todo/scripts/create.sh "[identifier]"
```

Now I'll edit the index.md file to:

- replace [todo-name] with the the [identifier].
- replace [todo-description] with the full description from $ARGUMENTS

@todos/[folder-name]-open/index.md

## Error Handling

- If folder creation fails, an error message will be displayed
- If template copy fails, the operation will be aborted
- All operations include proper error checking and validation
