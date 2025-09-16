---
argument-hint: [todo folder path], [instruction]
description: Architect Mobile App feature
---

# app-architecture

Run the `app-architect` agent to produce evidence-backed research and repo-ready configs.  
Outputs **complexity** (not time) and does **not** create an implementation plan.

## Usage

/app:architect [@todo/<folder-name>] <architect topic or question>

## Examples

/app:architect @todo/2025-09-05-renovate-setup Renovate bot setup for monorepo with asdf, bun workspaces, and uv
/app:architect @todo/2025-07-08-upgrade-react-native-and-expo-to-latest-versions

## What it does

1. Launches `app-architect` with description of where to find existing todo research and task description
2. Writes `@todo/<folder-name>/architecture.md` and updates `index.md`.
3. Creates a git commit for branch with the research

➡ For the full output contract (best-practice examples via Context7 & web, **Files of Interest with full paths**, relevant **code examples from the codebase and documentation**, decision matrix, troubleshooting, and **Complexity Assessment**), see:
`@.claude/agents/app-architect.md`
