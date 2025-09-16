# tools/plan

Generate an implementation plan from an existing research package using `tool-implementation-planer`.  
Produces a sequenced plan with complexity labels — **no timelines or time estimates**. May supplement gaps with Context7 and the web.

## Usage

/tools/plan [@todo/<folder-name>] <description>

### Common flags (forwarded to the agent)

## Examples

/tools:plan @todo/2025-09-05-renovate-setup Create a plan based on the research. It should include steps for a local setup with
`task deps:check`, `task deps:update` and `task deps:install` on task top-level calling out to the included taskfile for each command as well as
a github action setup for renovate github issue and PR creation (automatic).

## What it does

1. Reads all documents in `@todo/<folder>`, with extra weight given to `research.md`.
2. Writes `@todo/<folder>/plan.md` (phases, WBS with owners, dependencies, acceptance checks, files to touch, complexity; plus security/quality/ops/change/cutover/rollback, risks).
3. Updates `@todo/<folder>/index.md` with plan status and artifacts.
4. Optionally supplements gaps with Context7/Web and records sources in an Evidence Log.

➡ For the full output contract, see:  
`@.claude/agents/tool-implementation-planer.md`
