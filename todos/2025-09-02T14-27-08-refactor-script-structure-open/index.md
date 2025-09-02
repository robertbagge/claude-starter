# Todo: refactor-script-structure

## Description

refactor todo script structure to have a single script for each todo command. Existing scripts in @.claude/commands/todo/scripts should be moved to @.claude/commands/todo/scripts/shared and then we should add a new script for each command that calls out to it's necessary scripts.

@.claude/commands/todo/scripts/create.sh
@.claude/commands/todo/scripts/list.sh

etc.

Each command should just refer to their one .sh command in the ## steps section. For example the @.claude/commands/todo/create.md should just call out to `@claude/commands/todo/scripts/create.sh`.
The "generate identifier" and "edit the index file instructions" should be intact

## Work Artifacts

| Agent        | File                   | Purpose                                          |
| ------------ | ---------------------- | ------------------------------------------------ |
| task-manager | index.md               | Task index and tracking                         |
| planner  | implementation_plan.md | Detailed step-by-step refactoring instructions  |

## Notes

[Any additional context or decisions]
