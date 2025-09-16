---
argument-hint: [todo folder path], [instruction]
description: Plan Mobile App feature
---

# mobile-app-planning

Read an existing research package and produce a concrete, sequenced, dependency-aware implementation plan for an Expo/React Native/Tamagui codebase. **No timelines or time estimates.** Research is a key input, and the task description also informs the plan. May supplement gaps with Context7 docs and web sources when needed.

## Usage

/app:plan [@todo/<folder-name>] <plan topic or question>

## Examples

/app:plan @todo/2025-09-05-renovate-setup-open
/app:plan @todo/2025-09-11-textfield-test-coverage-open

## Workflow

When this command is executed:

1. Parse `research.md`, `index.md`, `architecture.md` as well as linked GitHub issues or Jira Tickets → extract scope, constraints, files of interest, best practices.
2. Make high-level plan in phases e.g -> 1. Test coverage and refactoring 2. Migration 3. etc,
3. Break down each phase in smaller steps
4. Emit `plan.md`, update `index.md` with status/artifacts.

## DO

1. Produce phases and steps describing the work that is planned
2. Focus on code/value
3. Support a TDD workflow red-green-refactor with phases/steps with clear boundaries
4. Inspect documentation with context7 mcp if necessary. Especially Expo, React Native and Tamagui
5. Read @docs/clean-docs/react to refresh your context of clean code and best practices
6. Reference tools used on codebase e.g. `task`, `bun`, `bunx`

## DO NOT

1. Care about time estimates, operational metrics or complexity measures
2. Create sub-tickets
3. Reference tools not used in codebase, e.g. `npm`, `npx`, `make`

## Output

1. Well-written plan in @todos/[folder-name]/plan.md
2. Updated file list in @todos/[folder-name]/index.md
