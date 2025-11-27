---
argument-hint: [tech-area-name] (optional, defaults to all)
description: Update tech-stack manifests with missing fields and new frameworks
---

# Update Tech Stack Manifests

Validate and update existing tech-stack manifests by checking against the spec and scanning for new frameworks.

**Tech Area:** $ARGUMENTS (if empty, update all manifests)

## Phase 1: Load Reference Spec

Read the manifest schema to understand expected structure:

1. Read `.claude/docs/tech-stack-schema.md`
2. Parse the Format code block to extract:
   - Expected top-level keys (with required/optional annotations from comments)
   - Expected `frameworks[]` entry fields
   - Expected `deployment` section fields
   - Expected `development` section fields
3. This is the source of truth for what a complete manifest should contain

## Phase 2: Load and Validate Existing Manifests

### Step 1: Find Manifests

If `$ARGUMENTS` is provided:
- Load only `docs/tech-stack/$ARGUMENTS.yaml`

If `$ARGUMENTS` is empty:
- Use Glob to find all `docs/tech-stack/*.yaml` files

### Step 2: Validate Each Manifest

For each manifest:
1. Parse the YAML content
2. Compare against the reference spec from Phase 1
3. Identify:
   - Missing top-level keys (including `deployment` and `development` sections)
   - Missing fields in each `frameworks[]` entry
   - Missing fields in `deployment` section
   - Missing fields in `development` section
4. Build a report of gaps per manifest

### Step 3: Report Findings

Present validation results to user:
- List each manifest with its missing keys/fields
- Group by severity (missing required vs optional fields)
- Highlight missing `deployment` or `development` sections

## Phase 3: Scan for New Frameworks

For each tech area being updated:

### Step 1: Infer Language/Ecosystem

From existing `frameworks[].name` entries, infer the primary language(s):
- JS/TS frameworks (expo, react, etc.) → scan `package.json`
- Go frameworks (gin, sqlc, etc.) → scan `go.mod`
- Python frameworks (fastapi, etc.) → scan `pyproject.toml`, `requirements.txt`
- Infrastructure (terraform, etc.) → scan `*.tf`, `Dockerfile`

### Step 2: Scan Dependency Files

Re-run the dependency scanning logic from `/tech-stack:create`:
- Find relevant dependency files in the codebase
- Extract framework/library names

### Step 3: Compare Against Manifest

- List frameworks found in dependencies but NOT in manifest
- These are candidates for addition

### Step 4: Report New Frameworks

Present discovered frameworks to user via AskUserQuestion:
- Show which new frameworks were found
- Let user select which ones to add to this tech area
- Allow user to skip all if none are relevant

## Phase 4: Scan for CI/CD Changes

Check for new or changed CI/CD workflows relevant to each tech area.

### Step 1: Find All Workflows

Use Glob to find:
- `.github/workflows/*.yaml`
- `.github/workflows/*.yml`

### Step 2: Compare Against Manifest

For each tech area being updated:
1. Get current `deployment.workflows[]` from manifest (if exists)
2. Associate workflows with tech area by:
   - Path filter matching (e.g., `paths: [mobile-app/**]`)
   - Filename convention (e.g., `mobile-app.yaml`)
3. Identify:
   - Workflows that match tech area but are NOT in manifest
   - Workflows in manifest that no longer exist

### Step 3: Report CI/CD Changes

Present discovered workflows to user via AskUserQuestion:
- Show new workflows found for this tech area
- Let user select which ones to add
- Highlight workflows that should be removed (file deleted)

### Step 4: Find Infrastructure Changes

Search for new Terraform or IaC directories:
- Look for `**/$tech_area/terraform/` directories
- Compare against existing `deployment.infrastructure[]`

Present findings to user for confirmation.

## Phase 5: Scan for Dev Tooling Changes

Check for new or changed dev tooling configs relevant to each tech area.

### Step 1: Scan for Taskfile Changes

Check if Taskfile path in manifest still exists:
- Verify `development.taskfile` path is valid
- Look for new Taskfiles in tech area directories

### Step 2: Scan for Linting Config Changes

Use Glob to find (exclude `**/node_modules/**`):
- `eslint.config.{js,mjs,cjs,ts}`, `.eslintrc*`
- `.golangci.yml`, `.golangci.yaml`
- `biome.json`, `ruff.toml`

Compare against `development.linting[]` in manifest:
- Identify new configs not in manifest
- Identify configs in manifest that no longer exist

### Step 3: Scan for Testing Config Changes

Use Glob to find:
- `jest.config.*`, `vitest.config.*`
- `pytest.ini`

Compare against `development.testing` in manifest.

### Step 4: Scan for Type Checking Config Changes

Use Glob to find:
- `tsconfig.json` files
- `mypy.ini`

Compare against `development.type_checking` in manifest.

### Step 5: Report Dev Tooling Changes

Present findings to user via AskUserQuestion:
- Show new dev tool configs found
- Let user select which ones to add
- Highlight configs that should be removed (file deleted)

## Phase 6: Populate Missing Fields

For each existing framework with missing fields:

### Resolution Strategies

Infer the appropriate resolution strategy based on field name:

**Context7 resolution** (field contains `context7` or `library_id`):
- Call `mcp__context7__resolve-library-id({ libraryName: "{framework.name}" })`
- Store the resolved ID

**URL discovery** (field contains `url` or `documentation`):
- Use `WebSearch` to find: `"{framework.name} official documentation site"`
- Extract relevant URLs from results
- Present to user for confirmation via AskUserQuestion

**Topic extraction** (field is `topics`):
- Call `mcp__context7__get-library-docs` to fetch documentation overview
- Extract available topic categories
- Present to user for confirmation

**User input required** (other fields):
- Use AskUserQuestion to prompt user for value

### Step: Execute Resolution

For each missing field in each framework:
1. Determine resolution strategy from field name
2. Execute the appropriate resolution
3. Collect the resolved value

## Phase 7: Add New Frameworks

For each framework selected by user in Phase 3:

1. Create a new framework entry with all fields from the spec
2. Populate each field using the resolution strategies from Phase 6:
   - Resolve Context7 library ID
   - Find documentation URLs
   - Fetch and confirm topics
3. Add to the manifest's `frameworks[]` array

## Phase 8: Update Deployment Section

For each tech area with CI/CD changes from Phase 4:

1. Create or update `deployment` section
2. Set `platform: github-actions` (or detected platform)
3. Add new workflows to `deployment.workflows[]`:
   - `path`: workflow file path
   - `description`: extracted from workflow `name:` field
4. Add new infrastructure entries to `deployment.infrastructure[]`
5. Remove entries for deleted files (with user confirmation)

## Phase 9: Update Development Section

For each tech area with dev tooling changes from Phase 5:

1. Create or update `development` section
2. Update `taskfile` path if changed
3. Add new linting configs to `development.linting[]`
4. Add new formatting configs to `development.formatting[]`
5. Update `development.testing` if changed
6. Update `development.type_checking` if changed
7. Remove entries for deleted files (with user confirmation)

## Phase 10: Write Updates

### Step 1: Generate Updated YAML

For each manifest with changes:
1. Merge new field values into existing structure
2. Add new framework entries
3. Update deployment and development sections
4. Preserve existing values (non-destructive)

### Step 2: Write Files

Use Write tool to update each modified manifest file.

### Step 3: Summary

Display a summary of all changes made:
- Number of manifests updated
- Fields populated per framework
- New frameworks added
- CI/CD workflows added/removed
- Dev tooling configs added/removed
- Any fields that couldn't be resolved (manual follow-up needed)

## Notes

- **Schema-driven**: Always reads spec from `.claude/docs/tech-stack-schema.md`, never hardcodes field expectations
- **Non-destructive**: Only adds missing fields, never removes or overwrites existing values (except for deleted files)
- **User confirmation**: New frameworks, workflows, and configs require explicit user approval before adding
- **Idempotent**: Running update multiple times is safe - it only fills gaps
- **Future-proof**: When SCHEMA.md changes, update automatically adapts
- **CI/CD detection**: Uses path filters and filename convention to associate workflows with tech areas
- **Dev tooling detection**: Uses directory proximity to associate configs with tech areas
