---
argument-hint: [branch or path filter]
description: Review local changes against clean code standards
---

# review

Review local git changes against project standards and output structured feedback.

## Usage

```
/review                           # Review all changes vs origin/main
/review origin/develop            # Review against specific branch
/review mobile-app/               # Only review files in path
```

## Workflow

### Step 1: Get Changed Files

**YOU (the orchestrator) must:**

1. **Get list of changed files**
   ```bash
   git diff origin/main --name-only
   ```

2. **Get file diffs for each changed file**
   ```bash
   git diff origin/main -- <file>
   ```

3. **Apply path filter if provided**
   - If argument looks like a path (contains `/`), filter files to only those matching
   - If argument looks like a branch, use that as the diff base instead of origin/main

### Step 2: Detect Tech Areas

**YOU (the orchestrator) must:**

Map changed files to tech areas based on path patterns:

| Path Pattern | Tech Area |
|--------------|-----------|
| `mobile-app/**` | mobile-app |
| `supabase/**` | supabase |
| `go-api/**` | go-api |
| `services/**` | go-api |
| `infra/**` | infra |
| Other | (general) |

Cross-reference with `docs/tech-stack/*.yaml` manifests if they exist.

### Step 3: Launch Code Reviewer Orchestrator

**YOU (the orchestrator) must:**

Use Task tool with subagent_type="code-reviewer":

```
Task: Review code changes

**Changed Files:**
[List each file with its full diff]

**Tech Areas:** [comma-separated detected areas, or "general" if none]

**Task Context:**
[Branch name or any context about what is being implemented]

**Review Context:**
[Any additional context from user instruction]

Orchestrate the review across specialized reviewers and produce a unified review.
```

The code-reviewer orchestrator will:
1. Resolve task context (from branch name, todo folder, or ask user)
2. Smart-select reviewers based on tech areas
3. Launch reviewers in parallel (functionality, code-quality, security, performance, privacy)
4. Synthesize findings into unified output

### Step 4: Output Results

**YOU (the orchestrator) must:**

Transform the agent's YAML output into readable Markdown:

```markdown
# Code Review

## Summary

**Verdict:** [APPROVE | REQUEST_CHANGES | COMMENT]

[Overview text from agent]

### Strengths
- [Good patterns from agent]

### Priority Issues
1. 🔴 [Critical issue] - `file:line`
2. 🟡 [Warning] - `file:line`
3. 🔵 [Suggestion] - `file:line`

---

## File: `path/to/file.ts`

### Line 15 - 🟡 Warning: Clean Code
[Message from agent]

[Details from agent]

**References:**
- [Reference links]

### Line 45 - ✅ Good: Clean Code
[Positive feedback from agent]

---

## File: `path/to/other.ts`

[Comments for this file]
```

## Severity Icons

- 🔴 Critical - Security, data integrity, breaking changes
- 🟡 Warning - Clean code violations, performance concerns
- 🔵 Suggestion - Improvements, best practices
- ✅ Good - Patterns worth highlighting

## DO

- Get full diffs before launching agent
- Detect tech areas from file paths
- Present clear, actionable output
- Group comments by file
- Highlight critical issues first in priority list
- Include positive feedback (✅ Good)

## DO NOT

- Skip getting the actual diffs
- Launch agent without file content
- Hide positive feedback
- Make the output too verbose
- Fail if no tech area detected (use general principles)
