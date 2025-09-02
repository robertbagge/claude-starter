# Implementation Plan: Refactor Todo Script Structure

## Overview

Refactor the todo command scripts to have a single entry point script for each command, with shared utilities moved to a dedicated shared folder. This will improve maintainability and create a cleaner separation between command logic and utility functions.

## Current State Analysis

### Current Structure

```
.claude/commands/todo/
├── scripts/
│   ├── todo_create_folder.sh
│   ├── todo_create_index.sh
│   ├── todo_get_folder_name.sh
│   ├── todo_list_tasks_reverse.sh
│   ├── todo_rename_completed.sh
│   └── todo_verify_folder.sh
├── create.md
├── complete.md
├── list.md
├── select.md
└── unselect.md
```

### Current Command Files Reference Pattern

Each .md file currently calls multiple individual scripts in sequence. For example:

- `create.md` calls: `todo_get_folder_name.sh`, `todo_create_folder.sh`, `todo_create_index.sh`
- `list.md` calls: `todo_list_tasks_reverse.sh`
- `complete.md` calls: `todo_rename_completed.sh`

## Target State

### New Structure

```
.claude/commands/todo/
├── scripts/
│   ├── create.sh        # Main script for create command
│   ├── complete.sh      # Main script for complete command
│   ├── list.sh          # Main script for list command
│   └── shared/          # Shared utility scripts
│       ├── todo_create_folder.sh
│       ├── todo_create_index.sh
│       ├── todo_get_folder_name.sh
│       ├── todo_list_tasks_reverse.sh
│       ├── todo_rename_completed.sh
│       └── todo_verify_folder.sh
├── create.md
├── complete.md
├── list.md
├── select.md
└── unselect.md
```

## Implementation Steps

### Step 1: Create Shared Directory Structure

1. Create `.claude/commands/todo/scripts/shared/` directory
2. Move all existing utility scripts to the shared folder:
   - Move `todo_create_folder.sh` → `shared/todo_create_folder.sh`
   - Move `todo_create_index.sh` → `shared/todo_create_index.sh`
   - Move `todo_get_folder_name.sh` → `shared/todo_get_folder_name.sh`
   - Move `todo_list_tasks_reverse.sh` → `shared/todo_list_tasks_reverse.sh`
   - Move `todo_rename_completed.sh` → `shared/todo_rename_completed.sh`
   - Move `todo_verify_folder.sh` → `shared/todo_verify_folder.sh`

### Step 2: Update Shared Scripts

Update all shared scripts to reference other shared scripts with the new path:

1. Check each shared script for references to other scripts
2. Update any script-to-script calls to use the new `shared/` path

### Step 3: Create Main Command Scripts

#### 3.1 Create `create.sh`

```bash
 #!/bin/bash
# Main script for todo:create command
# Usage: create.sh [identifier]

IDENTIFIER="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# Get folder name with timestamp
FOLDER_NAME=$("$SHARED_DIR/todo_get_folder_name.sh" "$IDENTIFIER")

# Create the folder
"$SHARED_DIR/todo_create_folder.sh" "$FOLDER_NAME"

# Create the index file
"$SHARED_DIR/todo_create_index.sh" "$FOLDER_NAME"

echo "✓ Task folder created: todos/${FOLDER_NAME}-open/"
echo "Note: Edit the index.md file to update [todo-name] and [todo-description]"
```

#### 3.2 Create `list.sh`

```bash
#!/bin/bash
# Main script for todo:list command

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# List all tasks in reverse chronological order
"$SHARED_DIR/todo_list_tasks_reverse.sh"
```

#### 3.3 Create `complete.sh`

```bash
#!/bin/bash
# Main script for todo:complete command

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"

# Rename the folder from -open to -completed
"$SHARED_DIR/todo_rename_completed.sh"
```

### Step 4: Update Command Markdown Files

#### 4.1 Update `create.md`

- Keep the "Generate identifier" instruction intact
- Replace all script calls with a single call to `create.sh`
- Keep the "edit the index file instructions" intact
- Updated script call should be:

  ```bash
  sh .claude/commands/todo/scripts/create.sh "[identifier]"
  ```

#### 4.2 Update `list.md`

- Replace all script calls with a single call:

  ```bash
  sh .claude/commands/todo/scripts/list.sh
  ```

- Remove the intermediate formatting steps (let the script handle output)

#### 4.3 Update `complete.md`

- Replace all script calls with a single call:

  ```bash
  sh .claude/commands/todo/scripts/complete.sh "[folder-name]"
  ```

### Step 5: Testing & Validation

1. Test each command to ensure it works correctly:
   - `/todo:list` - Should list all tasks
   - `/todo:create "test task"` - Should create a new task folder
   - `/todo:complete` - Should rename folder
2. Verify all paths are correct and scripts are executable
3. Ensure error handling is preserved

## Special Considerations

### For the AI Agent Implementation

1. **Preserve Functionality**: The refactoring must maintain all existing functionality
2. **Identifier Generation**: In `create.md`, the AI agent still needs to generate the identifier from the description - this stays as an instruction in the markdown file
3. **Index File Editing**: In `create.md`, the AI agent still needs to edit the index.md file after creation - this instruction remains in the markdown file
4. **Script Permissions**: Ensure all new scripts have executable permissions (`chmod +x`)
5. **Path References**: Use relative paths from script location, not from working directory
6. **Error Handling**: Preserve all error handling from original scripts

### Migration Order

1. First create the shared directory and move files
2. Update internal references in shared scripts
3. Create new main command scripts
4. Update markdown files one by one
5. Test each command after updating

## Success Criteria

- [ ] All existing utility scripts moved to `shared/` folder
- [ ] Five new main command scripts created (`create.sh`, `list.sh`, `complete.sh`, `select.sh`, `unselect.sh`)
- [ ] All command markdown files updated to use single script calls
- [ ] All commands functioning correctly
- [ ] No broken references or paths
- [ ] Error handling preserved
- [ ] Special AI agent instructions (identifier generation, index editing) preserved in markdown files

## Rollback Plan

If issues arise:

1. Scripts are versioned in git - can revert changes
2. Test one command at a time to isolate issues
3. Keep original script functionality intact in shared folder
