---
argument-hint: [todo folder path], [instruction]
description: Create implementation plan from research output
---

# plan

**Create Implementation Plan from Research Output**

This command continues where `/research` stops. It asks the user which option to proceed with, then launches the `plan-architect` agent to design architecture, data model, and phased task breakdown.

**Output:**
- `plan.md` - Complete implementation plan with architecture, phases, code snippets
- `implementation_checklist.md` - Simple checkbox list for tracking progress

## Usage

```
/plan @todo/<folder-name> [optional additional context]
```

## Examples

```
/plan @todo/2025-01-20-trip-list-view
/plan @todo/2025-01-20-trip-list-view Proceed with Option A
```

## Workflow

### Phase 0: Input Validation & Option Selection

**YOU (the orchestrator) must:**

1. **Read research.md from todo folder**
   ```
   Read @todo/<folder-name>/research.md
   ```

2. **Parse Section 5 (Solution Space) to extract options**

   Look for patterns like:
   - `### Option A: [Name]`
   - `### Option B: [Name]`
   - Score/complexity in option descriptions

3. **Parse Section 6 (Recommendation) to get recommended option**

   Extract:
   - Recommended option name
   - Key reasons for recommendation
   - Confidence level

4. **Detect tech areas from research/ folder**

   Scan filenames in `@todo/<folder-name>/research/`:
   ```
   codebase-survey-mobile-app.md  → mobile-app
   codebase-survey-go-api.md      → go-api
   codebase-survey-supabase.md    → supabase
   ```

5. **Check if user provided option in instruction**

   If instruction contains "Option A", "Option B", etc., use that option.

6. **Otherwise, present options to user**

   Use AskUserQuestion to present options:

   ```
   Research recommends: [Recommended Option Name]
   Confidence: [High/Medium/Low]

   Which option would you like to proceed with?

   [Use AskUserQuestion with options extracted from Section 5]
   - Option A: [Name] - [Brief description from research]
   - Option B: [Name] - [Brief description]
   - Option C: [Name] - [Brief description]
   ```

7. **Wait for user to select option before proceeding**

### Phase 1: Launch Plan Architect Agent

**YOU (the orchestrator) must:**

1. **Resolve absolute paths**

   Get repository root and construct absolute paths:
   - Research folder: `{repo_root}/todos/<folder-name>`
   - Output folder: `{repo_root}/todos/<folder-name>`

2. **Launch plan-architect agent**

   Use Task tool with subagent_type="plan-architect":

   ```
   Task: Create implementation plan for [task name]

   **Selected Option:** [Option name selected by user]

   **Tech Areas:** [comma-separated list from detected areas]

   **Research Folder Path:** [absolute path to todo folder]

   **Output Folder Path:** [absolute path to todo folder]

   **Task Context:**
   [Brief description from index.md]

   **Key Constraints:**
   [Any constraints mentioned by user or in research]

   The agent should:
   1. Read all research appendices
   2. Load tech-stack manifests and clean code docs
   3. Design architecture (ASCII + Mermaid diagrams)
   4. Design data model if needed
   5. Create phased task breakdown with dependencies
   6. Include test strategy per step
   7. Write complete plan to plan.md
   ```

3. **Wait for agent to complete**

### Phase 2: Build Implementation Checklist

**YOU (the orchestrator) must:**

1. **Read the generated plan.md**
   ```
   Read @todo/<folder-name>/plan.md
   ```

2. **Extract tasks from phases**

   Parse each phase and step to create checkbox items:
   - Phase headers become section headers
   - Steps become checkbox items
   - Note blocking dependencies

3. **Generate implementation_checklist.md**

   ```markdown
   # Implementation Checklist

   Track implementation progress by checking off completed items.

   ## Dependency Overview

   ```mermaid
   graph LR
       P1[Phase 1: Foundation] --> P2[Phase 2: Backend]
       P1 --> P3[Phase 3: Frontend]
       P2 --> P4[Phase 4: Integration]
       P3 --> P4

       style P2 fill:#90EE90
       style P3 fill:#90EE90
   ```

   **Parallel execution:** Phases 2 and 3 can run simultaneously after Phase 1 completes.

   ---

   ## Phase 1: [Phase Name]

   - [ ] Step 1.1: [Step description]
   - [ ] Step 1.2: [Step description]
   - [ ] Validation: [validation command]

   ## Phase 2: [Phase Name]

   - [ ] Step 2.1: [Step description]
     - Blocked by: Phase 1
   - [ ] Step 2.2: [Step description]

   ## Phase 3: [Phase Name]

   - [ ] Step 3.1: [Step description]
     - Blocked by: Phase 1
   - [ ] Step 3.2: [Step description]

   ## Phase 4: [Phase Name]

   - [ ] Step 4.1: [Step description]
     - Blocked by: Phases 2+3
   - [ ] Final validation

   ---

   ## Final Verification

   - [ ] CI passes (`task ci`)
   - [ ] PR ready for review

   ---

   ## Notes

   [Space for implementation notes, blockers, decisions]
   ```

4. **Write implementation_checklist.md**
   ```
   Write @todo/<folder-name>/implementation_checklist.md
   ```

### Phase 3: Update Index & Commit

**YOU (the orchestrator) must:**

1. **Update index.md with new artifacts**

   Add to artifacts list:
   ```markdown
   ## Artifacts
   - `index.md` - Task definition
   - `research.md` - Research findings
   - `research/` - Research appendices
   - `plan.md` - Implementation plan
   - `implementation_checklist.md` - Progress tracking
   ```

2. **Commit changes**

   ```bash
   git add todos/<folder-name>/plan.md todos/<folder-name>/implementation_checklist.md todos/<folder-name>/index.md
   git commit -m "plan: create implementation plan for <task-name>

   - Selected option: [Option name]
   - Tech areas: [areas]
   - Phases: [N phases]
   - Architecture: [brief description]"
   ```

## Implementation Checklist Template

The checklist format is intentionally simple - just markdown checkboxes:

```markdown
# Implementation Checklist

## Phase 1: [Name]
- [ ] Task description
- [ ] Another task

## Phase 2: [Name]
- [ ] Task description
  - Blocked by: Phase 1
- [ ] Another task

## Final Verification
- [ ] All tests pass
- [ ] TypeScript compiles
- [ ] PR ready
```

## Success Criteria

Your plan command is successful when:

1. ✅ User was asked to select an option (or option was provided)
2. ✅ plan-architect agent was launched with full context
3. ✅ plan.md contains architecture diagrams (both ASCII and Mermaid)
4. ✅ plan.md contains phased task breakdown with code snippets
5. ✅ plan.md contains test strategy per step
6. ✅ implementation_checklist.md extracts all tasks as checkboxes
7. ✅ Dependencies are noted in checklist (Blocked by: ...)
8. ✅ index.md is updated with new artifacts
9. ✅ Changes are committed to git

## What NOT to Do

- ❌ Skip option selection (always confirm with user)
- ❌ Add complexity ratings or time estimates
- ❌ Create additional files beyond plan.md and implementation_checklist.md
- ❌ Use tools not in codebase (`npm`, `make` - use `task`, `bun`)
- ❌ Skip clean code doc loading (agent must load them)
