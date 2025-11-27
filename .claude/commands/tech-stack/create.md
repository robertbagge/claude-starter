---
argument-hint: [tech-area-name]
description: Create a tech area manifest in docs/tech-stack/
---

# Create Tech Stack Manifest

Create a YAML manifest for a tech area that can be consumed by research agents.

**Tech Area:** $ARGUMENTS

## Phase 1: Scan Codebase for Frameworks

Search the entire codebase for dependency manifests to discover frameworks in use.

### Step 1: Find all dependency files

Use Glob to find:
- `**/package.json` (JS/TS)
- `**/go.mod` (Go)
- `**/pyproject.toml` and `**/requirements.txt` (Python)
- `**/Cargo.toml` (Rust)
- `**/*.csproj` (C#/.NET)
- `**/Gemfile` (Ruby)
- `**/Dockerfile` (Container images)
- `**/*.tf` (Terraform)

### Step 2: Extract frameworks from each file type

For each found file, read and extract:
- `package.json`: Extract keys from `dependencies` and `devDependencies`
- `go.mod`: Extract module paths from `require` blocks
- `pyproject.toml`: Extract from `[project.dependencies]` or `[tool.poetry.dependencies]`
- `requirements.txt`: Extract package names (before `==` or `>=`)
- `Cargo.toml`: Extract from `[dependencies]`
- `Dockerfile`: Extract `FROM` base images
- `*.tf`: Extract provider names from `required_providers`

### Step 3: Deduplicate and categorize

Group discovered frameworks by type:
- **JavaScript/TypeScript**: expo, react-native, tamagui, react-query, etc.
- **Go**: gin, echo, chi, sqlc, pgx, etc.
- **Python**: fastapi, celery, sqlalchemy, etc.
- **Infrastructure**: terraform providers, docker images, etc.

### Step 4: Detect Dev Tooling

Identify task runner and dependency manager for this tech area:

**Task Runner:**
- Check for `Taskfile.yaml` or `Taskfile.yml` in relevant paths → `taskfile`
- Check for `Makefile` → `make`
- Check for scripts in `package.json` as primary runner → `bun` (with package.json)

**Dependency Manager** (infer from dependency files found):
- `package.json` + `bun.lock` → `bun`
- `package.json` + `package-lock.json` → `npm`
- `pyproject.toml` + `uv.lock` → `uv`
- `pyproject.toml` + `poetry.lock` → `poetry`
- `go.mod` → `go`
- `*.tf` files → `terraform`
- `Cargo.toml` → `cargo`

Present detected tooling to user for confirmation via AskUserQuestion.

## Phase 2: User Framework Selection

Use AskUserQuestion with multiSelect to let user choose which frameworks belong to this tech area.

Present frameworks grouped by language/type. The user selects which ones are relevant to "$ARGUMENTS" (which is an abstract concept - a layer/concern of the system, not necessarily a folder).

Allow user to type additional frameworks not detected.

## Phase 3: Fetch Topics and URLs from Context7

For each selected framework:

1. Call `mcp__context7__resolve-library-id` to get the Context7 library ID
   - **Store the returned `context7CompatibleLibraryID`** for the manifest (e.g., `/expo/expo`)
   - If resolution fails, leave `context7_library_id` empty (agents will retry at runtime)
2. Call `mcp__context7__get-library-docs` to fetch documentation overview
3. Extract available topic categories from the docs
4. **Find official documentation URLs** using `WebSearch`:
   - Search query: `"{framework-name} official documentation site"`
   - Extract relevant doc URLs from results (main docs, API reference, guides)
   - Common patterns: `docs.{framework}.dev`, `{framework}.dev/docs`, `pkg.go.dev/...`
5. Present topics and discovered URLs to user for confirmation/modification via AskUserQuestion
   - Allow user to add additional URLs or remove irrelevant ones

## Phase 4: Detect Clean Code Path

1. Check if `docs/clean-code/$ARGUMENTS/` exists → use it directly
2. If not, infer from selected frameworks' primary language:
   - JS/TS frameworks → check for `docs/clean-code/react/` or `docs/clean-code/typescript/`
   - Go frameworks → check for `docs/clean-code/go/`
   - Python frameworks → check for `docs/clean-code/python/`
3. If multiple languages or no matching docs found, use AskUserQuestion:
   - List available clean-code directories found in `docs/clean-code/`
   - Include option "Use general guidelines" → `docs/clean-code/general`
   - Include option "Leave blank" → omit field

## Phase 5: Scan CI/CD Configuration

Scan for GitHub Actions workflows and infrastructure-as-code relevant to this tech area.

### Step 1: Find CI/CD Workflow Files

Use Glob to find:
- `.github/workflows/*.yaml`
- `.github/workflows/*.yml`

### Step 2: Associate Workflows with Tech Area

For each workflow found:
1. Read the file content
2. Extract workflow metadata:
   - `name:` field for description
   - `on.push.paths` or `on.pull_request.paths` for path filters
3. Associate with this tech area by:
   - **Primary**: Path filter matching (e.g., `paths: [mobile-app/**]` → `mobile-app`)
   - **Secondary**: Filename convention (e.g., `mobile-app.yaml` → `mobile-app`)
4. Skip workflows that don't match this tech area

### Step 3: Present Findings

Use AskUserQuestion (multiSelect) to confirm which workflows belong to this tech area.
Show the workflow path and name for each option.

### Step 4: Find Infrastructure-as-Code

Search for Terraform or other IaC directories relevant to this tech area:
- Look for `**/$ARGUMENTS/terraform/` directories
- Look for `**/terraform/*.tf` files mentioning the tech area
- Include paths like `google-cloud/` if tech area is `infra`

Present IaC findings to user for confirmation.

## Phase 6: Scan Dev Tooling Configuration

Scan for linting, formatting, testing, and type checking configs relevant to this tech area.

### Step 1: Find Taskfile

Look for Taskfile specific to this tech area:
- Check `$ARGUMENTS/Taskfile.yaml` or `$ARGUMENTS/Taskfile.yml`
- Check subdirectories of common module roots

### Step 2: Find Linting Configs

Use Glob to find (exclude `**/node_modules/**`):
- `eslint.config.{js,mjs,cjs,ts}` (ESLint flat config)
- `.eslintrc*` (ESLint legacy)
- `.golangci.yml` or `.golangci.yaml` (Go)
- `biome.json` (Biome)
- `ruff.toml` or `pyproject.toml` with `[tool.ruff]` (Python)

Associate with tech area by directory path.

### Step 3: Find Formatting Configs

Use Glob to find:
- `.prettierrc*` or `prettier.config.*` (Prettier)
- `biome.json` (Biome also handles formatting)
- Note: `gofmt` has no config file (Go standard)

### Step 4: Find Testing Configs

Use Glob to find:
- `jest.config.*` (Jest)
- `vitest.config.*` (Vitest)
- `pytest.ini` or `pyproject.toml` with `[tool.pytest]` (Python)
- Note: Go uses standard `go test` with no config

Associate with tech area by directory path.

### Step 5: Find Type Checking Configs

Use Glob to find:
- `tsconfig.json` in module roots (TypeScript)
- `mypy.ini` or `pyproject.toml` with `[tool.mypy]` (Python)
- Note: Go has built-in type checking

### Step 6: Present Findings

Use AskUserQuestion to confirm dev tooling for this tech area:
- Show detected linters, formatters, testing frameworks, type checkers
- Allow user to correct or add missing tools

## Phase 7: Scan for ADRs and Related Docs

### Step 1: Find Relevant ADRs

Search `docs/adr/*.md` for ADRs relevant to this tech area:

1. Use Grep to search ADR **content** for mentions of:
   - Tech area name or parts of it (e.g., for `mobile-app` search: `mobile`, `app`, `frontend`)
   - Selected framework names (e.g., `expo`, `clerk`, `supabase`, `relay`)
   - Framework-related terms from topics (e.g., `authentication`, `navigation`, `routing`)
2. Optionally check `tech_area_tags` frontmatter if present (bonus signal)
3. Present matched ADRs to user via AskUserQuestion (multiSelect)
4. Allow user to deselect false positives or add ADRs not detected

### Step 2: Find Related Docs

Search `docs/` for other relevant documentation (excluding `docs/clean-code/`, `docs/tech-stack/`, `docs/adr/`):

1. Check if `docs/$ARGUMENTS/` folder exists → include all docs in it
2. Use Grep to search other doc folders for mentions of selected framework names
3. Present matched docs to user via AskUserQuestion (multiSelect)
4. Allow user to deselect or add docs not detected

## Phase 8: Generate Manifest

Create the manifest at `docs/tech-stack/$ARGUMENTS.yaml`.

**Refer to `.claude/docs/tech-stack-schema.md` for the manifest format.**

The schema file contains:
- Complete field definitions with required/optional annotations
- Example manifest for reference

Populate all fields gathered from previous phases:
- `tech_area`, `display_name`, `description` from user input
- `task_runner`, `dependency_manager` from Phase 1 Step 4
- `clean_code_path` from Phase 4
- `frameworks[]` with `name`, `context7_library_id`, `documentation_urls`, `topics` from Phases 2-3
- `deployment` with `platform`, `workflows[]`, `infrastructure[]` from Phase 5
- `development` with `taskfile`, `linting[]`, `formatting[]`, `testing`, `type_checking` from Phase 6
- `pattern_categories`, `best_practice_categories`, `anti_pattern_hints` derived from framework types
- `relevant_adrs`, `related_docs` from Phase 7

## Phase 9: Write and Confirm

1. Create `docs/tech-stack/` directory if it doesn't exist
2. Write the YAML manifest to `docs/tech-stack/$ARGUMENTS.yaml`
3. Display the created manifest to the user
4. Confirm success

## Notes

- Tech area is an abstract concept (layer/concern), not necessarily tied to a folder
- Framework discovery scans the entire codebase, not just specific directories
- `context7_library_id` is optional - if empty, agents resolve at runtime
- `documentation_urls` enables direct web fetching without search (list supports multiple doc sites per framework)
- Topics are suggestions - consuming agents may fetch additional topics as needed
- CI/CD workflows are associated by path filters or filename convention
- Dev tooling is associated by directory path proximity to tech area
