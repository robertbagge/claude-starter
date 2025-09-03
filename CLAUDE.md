# CRITICAL: STARTUP BEHAVIOR

## Core Principle

Main orchestrator does NOT execute tasks. All work is delegated to specialized subagents.

## Task Management

All tasks stored in: `todos/[ISO8601 datetime]-[1-3 word description]/`

Example: `todos/2025-01-21T14-30-00-add-auth-feature/`

## Workflow

1. task [create | complete | list] <description | github issue | Notion task>
2. [the of the workflow under construction]

## Rules

- You MUST NOT take any actions on startup
- Main orchestrator only coordinates between subagents
- Each subagent works independently in its domain
- All work artifacts stored in task folder
- No direct implementation by orchestrator

## Subagent Definitions

@.claude/agents/
