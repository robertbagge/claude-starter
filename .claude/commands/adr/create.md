---
argument-hint: [PR URLs | doc links | file paths | description]
description: Create ADR from PRs, docs, code, or decisions
---

# adr:create

Create Architecture Decision Record from sources: PRs, documentation, code files, or descriptions.

## Usage

```bash
/adr:create [sources and/or description]
```

## Examples

```bash
/adr:create https://github.com/owner/repo/pull/123 "Decision to use React Query for server state"
/adr:create @mobile-app/src/auth/AuthProvider.tsx "OAuth implementation approach"
/adr:create https://docs.expo.dev/guides/authentication/ "User authentication strategy"
/adr:create "Split user_account and user_profiles tables for SRP"
```

## Steps

### 1. Parse Input

Extract from $ARGUMENTS:
- PR URLs (github.com/*/pull/*)
- File paths (@path or relative)
- Doc URLs (https://*)
- Description text

### 2. Fetch Sources

**PRs:**
```bash
gh pr view <pr> --json number,title,body,files,diff,comments
gh pr diff <pr>
```

**Docs:**
```bash
# Use WebFetch for external docs
# Use Read for local docs
```

**Code:**
```bash
# Use Read for file paths
# Use Grep/Glob for related files
```

### 3. Determine ADR Number

```bash
# Find highest existing ADR number
find docs/adr -name "ADR-*.md" | sed 's/.*ADR-\([0-9]*\).*/\1/' | sort -n | tail -1
# Increment by 1
```

### 4. Analyze Decision

From sources, identify:
- **Problem**: What issue/constraint drove this?
- **Decision**: What was chosen?
- **Alternatives**: What else was considered?
- **Consequences**: Trade-offs (positive/negative/neutral)
- **Tech areas**: Which parts of the system affected?

### 5. Generate Title & Slug

- Title: Clear, action-oriented (e.g., "Use NanoID for Analytics Tracking")
- Slug: Lowercase hyphenated version

### 6. Populate Metadata

```yaml
adr_number: {next_number}
title: {generated_title}
date: {today's date YYYY-MM-DD}
author: {from git config user.name}
status: Accepted
tech_area_tags:
  - {inferred from analysis}
```

### 7. Write ADR

Use template from `@.claude/templates/adr.template.md`:
- Fill metadata
- Write Context (problem statement)
- Write Decision (what + why)
- List Consequences (honest trade-offs)
- Document Alternatives Considered
- Add References (link to PRs, docs, code)

Write to: `docs/adr/ADR-{number}-{slug}.md`

### 7.5. Update Tech Stack Manifests

After writing the ADR, add it to relevant tech stack manifests:

1. Use Glob to find all `docs/tech-stack/*.yaml` files
2. For each manifest:
   - Read the manifest to get `tech_area` and `frameworks[].name`
   - Check if any of the ADR's `tech_area_tags` match:
     - Direct match with `tech_area` or parts of it (e.g., `mobile` matches `mobile-app`)
     - Match with any framework name (e.g., `clerk` matches manifest with clerk framework)
     - Cross-cutting tags like `authentication`, `testing`, `architecture` may match multiple manifests
3. If match found:
   - Add ADR path to `relevant_adrs` list (create list if doesn't exist)
   - Ensure no duplicates
   - Write updated manifest back
4. Report which manifests were updated

Matching should be fuzzy/inclusive - better to add and let user remove than miss relevant ADRs.

### 8. Commit

```bash
git add docs/adr/ADR-{number}-{slug}.md
git add docs/tech-stack/*.yaml  # Include any updated manifests
git commit -m "$(cat <<'EOF'
docs: add ADR-{number} - {title}

{one-line summary of decision}
EOF
)"
```

## Tech Area Tag Inference

Map sources to tags:
- `/mobile-app/` → frontend, mobile
- `/mobile-api/` → backend, api
- `/auth/` → security, authentication
- `/db/`, `/migrations/` → database, data-model
- `/infra/`, `Dockerfile` → infrastructure
- State management files → performance, architecture
- Test files → testing
- UI components → ui, frontend

## Quality Checklist

- [ ] Context explains **why** decision was needed
- [ ] Decision uses active voice ("We will...")
- [ ] Alternatives show due diligence
- [ ] Consequences are honest (include negatives)
- [ ] Tech tags accurately reflect affected areas
- [ ] References link back to all sources
- [ ] File follows template structure

## Error Handling

- If no sources provided, ask user for clarification
- If git user not configured, use "Unknown"
- If ADR directory doesn't exist, create it
- If number inference fails, start at 001
