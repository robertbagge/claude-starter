# tool-research

Run the `tool-research-specialist` agent to produce evidence-backed research and repo-ready configs.  
Outputs **complexity** (not time) and does **not** create an implementation plan.

## Usage

/tool-research [@todo/<folder-name>] <research topic or question>

## Examples

/tool-research @todo/2025-09-05-renovate-setup Renovate bot setup for monorepo with asdf, bun workspaces, and uv
/tool-research @todo/2025-07-08-upgrade-react-native-and-expo-to-latest-versions

## What it does

1. Launches `tool-research-specialist`.
2. Writes `@todo/<folder-name>/research.md` and updates `index.md`.
3. Creates a git commit for branch with the research

➡ For the full output contract (best-practice examples via Context7 & web, **Files of Interest with full paths**, relevant **code samples from the codebase**, decision matrix, troubleshooting, and **Complexity Assessment**), see:
`@.claude/agents/tool-research-specialist.md`
