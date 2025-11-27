# Tech-Stack Manifest Schema

This document defines the format for tech-stack manifest files (`docs/tech-stack/*.yaml`).

## Format

```yaml
# Required: Unique identifier for this tech area (snake_case)
tech_area: string

# Required: Human-readable name
display_name: string

# Required: Brief description of this tech area's purpose
description: string

# Optional: Task runner used in this tech area
task_runner: taskfile | make | bun

# Optional: Dependency manager for this tech area
dependency_manager: bun | npm | uv | poetry | go | terraform | cargo

# Optional: Path to clean code guidelines
clean_code_path: string  # e.g., docs/clean-code/react

# Required: List of frameworks/libraries in this tech area
frameworks:
  - # Required: Framework/library name
    name: string

    # Optional: Pre-resolved Context7 library ID (e.g., /expo/expo)
    # If empty, research agents will resolve at runtime
    context7_library_id: string

    # Optional: Official documentation URLs for direct fetching
    # List supports multiple URLs (main docs, API reference, guides)
    documentation_urls:
      - string

    # Required: Topics to research for this framework
    topics:
      - string

# Optional: Deployment configuration (CI/CD, workflows, infrastructure)
deployment:
  # CI/CD platform used
  platform: github-actions | gitlab-ci | circleci | jenkins

  # List of CI/CD workflow files
  workflows:
    - path: string        # e.g., .github/workflows/mobile-app.yaml
      description: string # Brief description of what the workflow does

  # Infrastructure-as-code locations (if applicable)
  infrastructure:
    - path: string  # e.g., mobile-api/terraform/
      tool: string  # e.g., terraform, pulumi

# Optional: Development tooling configuration
development:
  # Path to module's Taskfile
  taskfile: string  # e.g., mobile-app/Taskfile.yml

  # Linting tools and their configs
  linting:
    - tool: string    # e.g., eslint, golangci-lint, biome, ruff
      config: string  # Path to config file

  # Formatting tools and their configs
  formatting:
    - tool: string    # e.g., prettier, gofmt, black
      config: string  # Path to config file (if applicable)

  # Testing framework
  testing:
    framework: string  # e.g., jest, vitest, pytest, go-test
    config: string     # Path to config file

  # Type checking tool
  type_checking:
    tool: string    # e.g., typescript, mypy, pyright
    config: string  # Path to tsconfig/mypy.ini

# Optional: Pattern categories for research agents
pattern_categories:
  - string

# Optional: Best practice categories to cover
best_practice_categories:
  - string

# Optional: Anti-patterns to document
anti_pattern_hints:
  - string

# Optional: Relevant Architecture Decision Records
relevant_adrs:
  - string  # path to ADR file

# Optional: Related documentation files
related_docs:
  - string  # path to doc file
```

## Example

```yaml
tech_area: mobile-app
display_name: Mobile App
description: React Native mobile application built with Expo

task_runner: taskfile
dependency_manager: bun
clean_code_path: docs/clean-code/react

frameworks:
  - name: expo
    context7_library_id: /expo/expo
    documentation_urls:
      - https://docs.expo.dev
      - https://docs.expo.dev/versions/latest/
    topics:
      - routing
      - navigation
      - file-system

  - name: react-native
    context7_library_id: /facebook/react-native
    documentation_urls:
      - https://reactnative.dev
    topics:
      - components
      - performance
      - gestures

deployment:
  platform: github-actions
  workflows:
    - path: .github/workflows/mobile-app.yaml
      description: Type checking, linting, testing on PR/push
    - path: .github/workflows/mobile-app-release.yaml
      description: EAS build and release workflow

development:
  taskfile: mobile-app/Taskfile.yml
  linting:
    - tool: eslint
      config: mobile-app/eslint.config.js
  formatting:
    - tool: prettier
      config: .prettierrc
  testing:
    framework: jest
    config: mobile-app/package.json
  type_checking:
    tool: typescript
    config: mobile-app/tsconfig.json

pattern_categories:
  - Component patterns
  - State management
  - Navigation patterns

best_practice_categories:
  - Performance optimization
  - Accessibility
  - Testing

anti_pattern_hints:
  - Avoid inline styles
  - Avoid anonymous functions in render

relevant_adrs:
  - docs/adr/ADR-001-mobile-framework.md

related_docs:
  - docs/mobile-app/development.md
```
