# tools/implement

Run the `tool-implementer` to execute @todo/<folder>/plan.md with a **verification-first** workflow.  
TDD for code; for tooling, use validator → dry-run → sandbox/fork → canary → live (constrained).  
After each step, the agent updates `implementation.md` and creates a commit.

## Usage

/tools/implement [@todo/<folder-name>]

## Examples

/tools/implement @todo/2025-09-05T12-00-00-renovate-setup

## What it does

1. Reads all files is `@todo/[folder-name]`. `plan.md` carries most weight
2. **VALIDATES SCOPE**: Confirms target paths and repository scope before implementation
3. For each step: writes a Verification Plan → runs "red" → implements → runs "green".
4. Appends results to implementation.md (full paths, repo snippets, doc examples with Evidence IDs, assertions, proof artifacts).
5. Creates a commit after each step (unless --no-commit).
6. Optionally supplements gaps via Context7/Web and logs new evidence.

## Critical Scope Rules

- Repository-wide tools (CI, linting, dependency management) → `/workspace/.github/`, `/workspace/Taskfile.yaml`
- Monorepo configurations must be at repository root, NOT in subdirectories
- Always confirm file paths in plan.md match the intended scope before implementing
