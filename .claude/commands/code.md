---
argument-hint: [todo folder path], [phase number or instruction]
description: Implement a phase from plan.md
---

# code

Implement phases from an existing plan using the appropriate methodology for each tech area.

## Usage

```
/code @todo/<folder-name> [phase number or instruction]
```

## Examples

```
/code @todo/2025-01-20-trip-list-view
/code @todo/2025-01-20-trip-list-view Phase 2
/code @todo/2025-01-20-trip-list-view Continue from step 2.3
```

## Workflow

### Phase 1: Load Context

**YOU (the orchestrator) must:**

1. **Read implementation_checklist.md**
   ```
   Read @todo/<folder-name>/implementation_checklist.md
   ```

2. **Identify available phases and their status**
   - Parse checkbox items to find completed vs pending phases
   - Note which phases are blocked by dependencies

3. **If phase specified in instruction, use that phase**

4. **Otherwise, present phase selection to user**

   Use AskUserQuestion:
   ```
   Available phases from implementation_checklist.md:

   - Phase 1: [Name] - [Status: Complete/In Progress/Pending]
   - Phase 2: [Name] - [Status] - Can run parallel with Phase 3
   - Phase 3: [Name] - [Status] - Can run parallel with Phase 2
   - Phase 4: [Name] - [Status] - Blocked by: Phases 2+3

   Which phase would you like to implement?
   ```

5. **Wait for user selection**

### Phase 2: Load Plan Details

**YOU (the orchestrator) must:**

1. **Read plan.md**
   ```
   Read @todo/<folder-name>/plan.md
   ```

2. **Extract selected phase details**
   - Objective
   - Steps with files, before/after code, test strategy, validation
   - Dependencies on other phases

3. **Detect tech areas from plan header**
   - Parse `**Tech Areas:** mobile-app, go-api, supabase`
   - **MUST** Load corresponding manifests for clean code paths

4. **Load clean code docs for detected areas**
   - **MUST** Read `docs/tech-stack/{area}.yaml` for each area
   - **MUST** Read **ALL** files from `clean_code_path` specified in manifest in **FULL**
   - **MUST** Fallback to reading **ALL** files in  `docs/clean-code/general/` if no manifest in **FULL**

### Phase 3: Implement

**YOU (the orchestrator) must:**

1. **For each step in the phase:**

   a. **Read the step details from plan.md**
      - Files to create/modify
      - Before/after code snippets
      - Test strategy
      - Validation command

   b. **Follow TDD methodology**
      - RED: Write failing test first
      - GREEN: Write implementation to pass test
      - REFACTOR: Clean up while keeping tests green

   c. **Run validation command**
      ```bash
      task test -- path/to/file  # or whatever plan specifies
      task typecheck
      ```

   d. **Commit after each step**
      ```bash
      git add <files from step>
      git commit -m "feat(<area>): <step description>"
      ```

   e. **Update implementation_checklist.md**
      - Mark completed step checkbox
      - Note any blockers or issues discovered

2. **After all steps complete:**
   - Run full CI check: `task ci`
   - Update phase status in checklist

### Phase 4: Report Completion

**YOU (the orchestrator) must:**

1. **Summarize what was implemented**
   - Steps completed
   - Files created/modified
   - Tests added

2. **Note any issues or follow-ups**
   - Blockers discovered
   - Deviations from plan (if any)

3. **Show next available phases**
   - What's now unblocked
   - Recommended next phase

## Core Principles

1. **Follow plan.md exactly** - Don't improvise or deviate
2. **TDD methodology** - RED → GREEN → REFACTOR → COMMIT
3. **Commit per step** - Never batch multiple steps
4. **Honest progress** - Only mark checkboxes when truly complete
5. **Clean code** - Follow guidelines from loaded docs

## DO

- Read all todo documents before implementing
- Follow the exact file paths and code from plan.md
- Run validation commands after each step
- Commit after each completed step
- Update implementation_checklist.md as you go
- Stop after completing the selected phase

## DO NOT

- Skip reading plan.md and clean code docs
- Improvise solutions not in the plan
- Batch multiple steps into one commit
- Mark checkboxes without actual working code
- Continue to next phase without user confirmation
