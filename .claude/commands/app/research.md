---
argument-hint: [todo folder path], [instruction]
description: Research mobile app feature
---

# mobile-app-research

**🚨 CRITICAL EXECUTION INSTRUCTIONS 🚨**
When this command is invoked, YOU (the assistant) must:

1. **DIRECTLY EXECUTE** the research yourself - DO NOT use the Task tool
2. **YOU ARE THE APP-RESEARCHER** - not launching one, BEING one
3. **CREATE** the research.md file using the Write tool
4. Your job is INCOMPLETE until research.md exists in the todos folder

**If plan mode is active:**

1. Complete ALL research using read-only tools (Read, Grep, Glob, Context7, etc.)
2. Prepare the complete research document content
3. Use ExitPlanMode to present your plan to create research.md
4. Only after approval, use Write tool to create the file

## Usage

/app:research [@todo/<folder-name>] <research topic or question>

## Examples

/app:research @todo/2025-09-05-renovate-setup Renovate bot setup for monorepo with asdf, bun workspaces, and uv
/app:research @todo/2025-07-08-upgrade-react-native-and-expo-to-latest-versions

## What YOU (the assistant) must do

1. **READ** the task in `@todo/<folder-name>/index.md` to understand the specific task
2. **RESEARCH** the task thoroughly using the tools available (USE THEM, don't just plan to)
   You ALWAYS use `context7` for dev documentation. You ALWAYS use `WebSearch`
   with current year (2025).
3. **WRITE** your complete research to `@todo/<folder-name>/research.md` using the Write tool
4. **VERIFY** the file was created - if not, your task failed
5. **UPDATE** the index.md if needed
6. **COMMIT** your changes to git

## Important Notes

- **DO NOT** use the Task tool to launch an agent
- **DO NOT** say "I will create" - actually CREATE the file
- **YOU MUST** produce the research.md file - your task is incomplete without it
- If plan mode is active, use only read-only tools for research, then use ExitPlanMode

## Scope Boundary

- This research **does not produce an implementation plan** (no step-by-step task breakdown, ticketing, or sequencing)
- Output is **research → options → single recommendation** only
- A separate implementation planner agent will own the execution plan

## Working Style (Code-First)

- Parse the task → gather assumptions → scan the repo to understand _how things are done today_
- Breadth-first scan of external sources (2024–present, official first) → shortlist → deep-dive top 2–3
- Fully read and understand all files in [clean-code-react](../../../docs/clean-code/react/) starting with the readme
- Prioritize **Clean Code & best practices** over existing repo conventions unless conflicting with explicit requirements
- Produce **small, composable changes** that the team can adopt incrementally

## What to Research for Each Task

- **Repo patterns**: component architecture, state mgmt, navigation (expo-router vs react-navigation), Tamagui tokens/themes, animation libs, data fetching, error handling, a11y
- **Idioms**: Expo Router layouts, linking, font loading, image handling, platform splits, performance (JSI, Reanimated), styling with Tamagui (tokens, variants, themes), testability
- **Clean Code**: naming, module boundaries, component size, hooks purity, dependency arrays, side-effect isolation, dead code, file structure
  - Reference: [clean-code-react](../../../docs/clean-code/react/)

## Tool Use Playbook

- **Context7** (IMPORTANT - use these exact tool names):
  1. First use `mcp__context7__resolve-library-id` with parameters like: `{"libraryName": "react-hook-form"}` to get the library ID
  2. Then use `mcp__context7__get-library-docs` with parameters like: `{"context7CompatibleLibraryID": "/react-hook-form/react-hook-form", "topic": "migration"}` to get documentation

- **Codebase**: `Glob`/`Grep` to find:
  - `app/`, `app/+layout.*` or `app/_layout.*`, route files; `app.json|app.config.*`
  - `tamagui.config.ts`, `@tamagui/*` usage; `TamaguiProvider` wiring
  - `react-native-reanimated`, `react-native-gesture-handler`, `expo-linking`, `expo-font`
  - Hooks/components that touch the task domain

- **Diagnostics**: `mcp__ide__getDiagnostics` (TypeScript, ESLint hints); `npx expo doctor` via `BashOutput` if safe

- **Safety**: Never execute unvetted web code. Prefer read-only commands; `KillBash` long runners

## Heuristics for Repo Scanning

- Grep examples:
  - `Grep('TamaguiProvider|Theme', ['**/*.{ts,tsx}'])`
  - `Grep('useEffect\(|useMemo\(|useCallback\(', ['**/*.{ts,tsx}'])` to flag side-effects/optimizations
  - `Grep('Link|Stack|Tabs|Slot', ['app/**/*.{ts,tsx}'])` for Expo Router
  - `Grep('Animated\.|useSharedValue|runOnJS', ['**/*.{ts,tsx}'])` for animation patterns

- Glob examples:
  - `Glob(['app/**/*', 'packages/**/*', 'tamagui.config.ts', 'app.config.*', 'babel.config.js'])`

## Output Contract

**CRITICAL**: You MUST write your research to `todos/[task-slug]/research.md` where [task-slug] is the actual directory name provided.
Use the Write tool to create this file with your complete research findings.

**Do NOT include an implementation plan.** Research, options, and a single justified recommendation only; execution will be handled by a separate agent.
Every section is required; if unknown, write "Unknown" and list next steps.

### 1. Task Interpretation & Goals

- Restate the task in one paragraph
- Success criteria (functional + maintainability)

### 2. Assumptions & Constraints

- Platform scope (iOS/Android/Web), workflow (managed/bare), Expo SDK if known
- Repo constraints (monorepo, packages, build flavors), third-party constraints

### 3. Repo Survey (Evidence: Repo)

- Files of interest with **full paths**
- For each, include **line ranges** and short snippets (< ~40 lines) that illustrate current patterns
- Notes on smell/opportunities (e.g., prop drilling, large components, inline styles vs Tamagui tokens)

### 4. External Evidence (Evidence: Context7/Web, primary sources preferred)

- Bullet list of relevant docs with **links** and key excerpts
- Prefer: expo.dev, reactnative.dev, tamagui.dev, official vendor GitHub, release notes

### 5. Options (2–4)

- For each option: description, **pros/cons**, sample code (idiomatic), migration impact
- **Weighted criteria** (default, can be tuned):
  - Clean Code & Maintainability **0.40**
  - Idiomatic Expo/RN/Tamagui **0.30**
  - Fit with Existing Codebase **0.20**
  - Risk/Complexity **0.10**
- Provide raw + weighted scores; each non-trivial score must cite **Evidence IDs**

### 6. Recommendation (Single)

- The chosen option with **why now**, trade-offs, and links to Evidence IDs
- Design notes: component boundaries, dependency flow, error handling, a11y, theming

### 7. Implementation Examples (Repo-aware)

- **Before/After** diffs with **file paths + line numbers**
- Keep examples small and paste-ready
- Show Tamagui token usage, variants, and theming where relevant
- Expo Router examples should reflect current router mode in the repo

### 8. Refactors & Incremental Improvements

- Small refactors that unlock the recommendation (e.g., extract hooks, introduce variants, normalize tokens)
- Mark each item with **Complexity = XS/S/M/L/XL** + brief rationale

### 9. Risks & Mitigations

- Each with: _How to detect_, _Fallback_, _Owner_

### 10. Validation & Checks

- Type safety (TS), ESLint rules, a11y pass, performance sanity (Reanimated worklets, memoization), deep links if applicable
- Minimal commands (safe): `npx expo doctor`, `tsc -p . --noEmit`

### 11. Evidence Index

- Table: ID, title, URL, publisher, pub date, accessed date, key claim, confidence 0–1, source type = **Context7|Web|Repo**

### 12. PR Checklist & Next Steps

- Checklist for reviewers (tests, screenshots, video/gifs if UI, docs updates)
- Follow-up tasks (atomic), each with **Complexity** only (no time estimates)

## Style & Quality Guardrails

- Favor composition over inheritance; small components; pure hooks; explicit deps
- **Tamagui**: prefer tokens/variants/themes; avoid inline style objects; co-locate variants; memo heavy components; use `Stack`/`XStack`/`YStack` semantics consistently
- **Expo Router**: idiomatic layouts, file-based routing, stable link schemes, predictable params
- **React**: strict mode readiness, stable refs, correct effect deps, split platform code (`*.ios.tsx`/`*.android.tsx`) when needed
- **Accessibility**: roles, labels, touch targets ≥ 44x44, contrast, `accessibilityHint` + `accessibilityLabel`
- **Performance**: image optimization, font loading strategy, avoid unnecessary re-renders, use worklets where appropriate

## Decision Rules

- When repo conventions conflict with best practices, **bias toward best practices** and call out migration steps
- If multiple options tie, choose the one that reduces long-term complexity and increases consistency

## Deliverables

- **PRIMARY REQUIRED**: `todos/[task-slug]/research.md` - YOU MUST CREATE THIS FILE using the Write tool
- Optional: targeted diffs via `Write` in `todos/[task-slug]/examples/*.diff`
- Remember: The research.md file MUST be created - your task is not complete until this file exists
