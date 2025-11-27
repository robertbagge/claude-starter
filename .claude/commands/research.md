---
argument-hint: [todo folder path], [instruction]
description: Research features across tech stack (mobile, API, database, services) with parallel agents and modular appendices
---

# research (v4)

**Multi-Area Parallel Agent-Based Research with Modular Appendices**

This command orchestrates research across multiple tech areas. For each area, specialized agents run in parallel, then findings are synthesized into a dual-audience research document:
- **research.md**: Human-readable synthesis with appendix summaries (~1000-1500 lines)
- **research/ folder**: Tech-area-specific appendix files for plan agent consumption (~3000-6000 lines total depending on areas)

**Research Agents**:
- `codebase-surveyor` - Surveys codebase architecture, patterns, and key files
- `framework-docs-researcher` - Fetches official framework docs via Context7
- `clean-code-analyzer` - Analyzes code against clean code principles
- `web-researcher` - Researches current best practices (2024-2025)

All agents use tech stack manifests from `docs/tech-stack/` when available, with fallback to codebase scanning.

## Architecture

### Phase 0: Tech Area Identification (You, the orchestrator)
- Discover available tech areas from `docs/tech-stack/*.yaml` manifests
- Read task definition from `@todo/<folder-name>/index.md`
- Analyze which discovered tech areas are relevant to the task
- Present findings in interactive wizard
- User confirms/adjusts tech areas (can add unlisted areas)

### Phase 1: Task Analysis (You, the orchestrator)
- For each confirmed tech area, determine research scope
- Prepare research briefs for area-specific agents

### Phase 2: Multi-Area Parallel Research (Specialized Agents)
For each tech area, launch 4 agents **in a single message** (parallel execution):
- `codebase-surveyor` - Scans codebase patterns for area
- `framework-docs-researcher` - Fetches official docs via Context7 for area
- `clean-code-analyzer` - Analyzes against clean code principles for area
- `web-researcher` - Researches current best practices for area

Example: 3 areas × 4 agents = 12 agents running in parallel

Each agent accepts an `area` parameter and returns its findings.

### Phase 3: Cross-Area Synthesis & Documentation (You, the orchestrator)
- Receive all agent reports (from Task tool results)
- **Synthesize research.md**: Sections 1-7 considering ALL tech areas
- **Create research/ folder**: Tech-area-specific appendices + shared appendices
- **Add appendix summaries** to research.md with links
- Update index.md
- Commit all files

### Output Structure
```
todos/2025-XX-XX-task-name/
├── index.md
├── research.md                                  # ~1000-1500 lines
└── research/
    # Tech-area-specific appendices (per confirmed area)
    ├── codebase-survey-mobile-app.md            # If mobile-app area
    ├── framework-docs-mobile-app.md
    ├── clean-code-mobile-app.md
    ├── web-research-mobile-app.md
    ├── codebase-survey-go-api.md                # If go-api area
    ├── framework-docs-go-api.md
    ├── clean-code-go-api.md
    ├── web-research-go-api.md
    # ... (more areas as needed)
    #
    # Shared cross-area appendices
    ├── evidence-index.md                        # All evidence from all areas
    ├── decision-context.md                      # Scoring analysis across areas
    ├── implementation-context.md                # Integration + refactors across areas
    └── risks.md                                 # Consolidated risks from all areas
```

## Usage

```
/research4 @todo/<folder-name> [optional additional context]
```

## Examples

```
/research4 @todo/2025-01-20-trip-sharing Add trip sharing across mobile + API + database
/research4 @todo/2025-01-20-form-validation Research form validation
```

## Workflow (Step by Step)

### Phase 0: Tech Area Identification

**YOU (the orchestrator) must:**

1. **Discover available tech areas from manifests**

   Use Glob to find all `docs/tech-stack/*.yaml` files.

   For each manifest found, use Read to extract:
   - `tech_area` - identifier (e.g., "mobile-app")
   - `display_name` - human-readable name
   - `description` - what this area covers
   - `frameworks[].name` - frameworks in use
   - `clean_code_path` - path to clean code docs (if set)
   - `relevant_adrs` - ADRs for context

   **If no manifests found:**
   No tech stack manifests exist yet. Suggest running `/tech-stack:create <area>` first,
   or allow user to specify areas manually (will use fallback codebase scanning).

2. **Read the task definition**
   ```
   Read @todo/<folder-name>/index.md
   ```

3. **Analyze which tech areas are relevant**

   Based on the task description, identify which discovered tech areas are involved.

   For each tech area from manifests, check if task mentions:
   - The tech area name or parts of it
   - Any of its framework names
   - Related keywords from description

4. **Present findings in interactive wizard**

   Use AskUserQuestion with multiSelect to present discovered tech areas:

   ```
   Based on the task "{task description}" and available tech stack manifests:

   **Discovered Tech Areas (from docs/tech-stack/):**
   ✓ mobile-app - {display_name}: {description} (frameworks: expo, tamagui, relay, ...)
   ✓ go-services - {display_name}: {description} (frameworks: gin, sqlc, ...)
   ✗ supabase - {display_name}: {description} (frameworks: supabase-js, ...)
   ✗ infra - {display_name}: {description} (frameworks: terraform, docker, ...)

   **Additional Options:**
   - Add unlisted tech area... (will use fallback codebase scanning)

   [Use AskUserQuestion with multiSelect: true]
   Pre-select areas that appear relevant based on task analysis.
   ```

5. **Handle unlisted tech areas**

   If user selects "Add unlisted tech area":
   - Prompt for tech area name
   - This area will use fallback discovery (scan codebase for frameworks)
   - Note: Consider running `/tech-stack:create <area>` after research to create manifest

6. **Confirm tech areas with user**

   Wait for user to confirm or adjust the tech area selection before proceeding.

### Phase 1: Task Analysis

**YOU (the orchestrator) must:**

1. **For each confirmed tech area, analyze research scope**
   - What needs to be built/changed in this area?
   - How does it integrate with other areas?
   - What are the key questions for this area?

2. **Prepare area-specific research briefs**

   For each confirmed tech area, you'll launch 4 agents:
   - `web-researcher` - Current best practices
   - `codebase-surveyor` - Understand current patterns
   - `framework-docs-researcher` - Official framework docs
   - `clean-code-analyzer` - Code quality violations

   Each agent needs:
   - **Task description**: The overall feature/problem
   - **Tech area**: Which area to focus on (from confirmed areas)
   - **Research brief**: What to focus on for this area
   - **Todo folder path**: For reference

### Phase 2: Multi-Area Parallel Research

**YOU (the orchestrator) must:**

1. **Launch ALL agents for ALL areas in PARALLEL** (single message with multiple Task calls)

   **CRITICAL:** Use a SINGLE message with MULTIPLE Task tool calls for parallel execution.

   For each confirmed tech area, launch 4 agents (codebase-surveyor, framework-docs-researcher, clean-code-analyzer, web-researcher).

   Example for 3 confirmed areas:
   ```
   I'm launching 12 research agents in parallel (3 areas × 4 agents):

   {area-1} agents:
   [Task tool call for web-researcher with area="{area-1}"]
   [Task tool call for codebase-surveyor with area="{area-1}"]
   [Task tool call for framework-docs-researcher with area="{area-1}"]
   [Task tool call for clean-code-analyzer with area="{area-1}"]

   {area-2} agents:
   [Task tool call for web-researcher with area="{area-2}"]
   [Task tool call for codebase-surveyor with area="{area-2}"]
   [Task tool call for framework-docs-researcher with area="{area-2}"]
   [Task tool call for clean-code-analyzer with area="{area-2}"]

   {area-3} agents:
   [Task tool call for web-researcher with area="{area-3}"]
   [Task tool call for codebase-surveyor with area="{area-3}"]
   [Task tool call for framework-docs-researcher with area="{area-3}"]
   [Task tool call for clean-code-analyzer with area="{area-3}"]
   ```

   Each agent receives in its prompt:
   - **Task description**: The overall feature/problem
   - **Tech area**: Which area to focus on
   - **Research brief**: Specific focus for this area
   - **Output folder path**: The **absolute path** to the research folder

   ⚠️ **CRITICAL**: Before launching agents, resolve the absolute output path:
   1. Get the repository root (e.g., `/Users/.../owllark-mono`)
   2. Construct absolute path: `{repo_root}/todos/<folder-name>/research`
   3. Pass this absolute path to ALL agent prompts

   Example: `/Users/robertbagge/code/owllark/owllark-mono/todos/2025-01-20-feature/research`

   Agents will write files like `{absolute_output_folder}/codebase-survey-{area}.md`

   Each agent checks for a manifest at `docs/tech-stack/{TECH_AREA}.yaml` to guide its research, with fallback to codebase scanning if no manifest exists.

2. **Wait for all agents to complete**
   - All agents run concurrently (12 agents for 3 areas, 16 for 4 areas, etc.)
   - Each returns its findings in its final message
   - Agent reports arrive as Task tool results
   - Group results by tech area for synthesis

### Phase 3: Cross-Area Synthesis & Documentation

**Information Flow**:
```
Agent Reports (grouped by tech area)
    ↓
PART 1: Build Tech-Area-Specific Appendices
    - For each area: codebase-survey-{area}.md
    - For each area: framework-docs-{area}.md
    - For each area: clean-code-{area}.md
    - For each area: web-research-{area}.md
    ↓
PART 2: Build Shared Foundation Appendices
    - evidence-index.md (all areas)
    - risks.md (all areas)
    ↓
PART 3: Cross-Area Synthesis (extract patterns across ALL areas)
    - Key Findings (5-7, considering all areas)
    - Analysis & Synthesis (cross-area integration)
    - Solution Space (3-4 options considering all areas)
    - Scoring & Recommendation (cross-area evaluation)
    ↓
PART 4: Complete Dependent Appendices
    - decision-context.md (needs scoring)
    - implementation-context.md (needs options, cross-area)
    ↓
PART 5: Finalize Main Document
    - research.md (sections 1-7 + appendix summaries)
    - Update index.md
    - Commit
```

**YOU (the orchestrator) must:**

1. **Receive agent reports**
   - Agent reports are returned in Task tool results
   - Group reports by tech area (by confirmed areas from Phase 0)
   - Each report contains detailed markdown findings
   - Reports are immediately available in-memory

2. **Review all agent insights per area**
   - **Codebase surveyors**: Current patterns, files, code samples per area
   - **Framework docs**: Official APIs, best practices per framework
   - **Clean code analyzers**: Violations, improvements per area
   - **Web researchers**: Production examples, patterns per area

3. **Verify agent output files exist**

   The `@todo/<folder-name>/research/` directory should now contain agent output files.
   You will now synthesize these tech-area-specific appendices across all areas.

---

### PART 1: Build Tech-Area-Specific Appendices

4. **For EACH confirmed tech area, create 4 appendices**

   Write each agent's output to files for that tech area.

   For each confirmed area, write agent reports directly to files:

   **4a. Codebase Survey - {area}**
   **Write**: `@todo/<folder-name>/research/codebase-survey-{area}.md`
   **Content**: Direct output from `codebase-surveyor` agent

   **4b. Framework Docs - {area}**
   **Write**: `@todo/<folder-name>/research/framework-docs-{area}.md`
   **Content**: Direct output from `framework-docs-researcher` agent

   **4c. Clean Code - {area}**
   **Write**: `@todo/<folder-name>/research/clean-code-{area}.md`
   **Content**: Direct output from `clean-code-analyzer` agent

   **4d. Web Research - {area}**
   **Write**: `@todo/<folder-name>/research/web-research-{area}.md`
   **Content**: Direct output from `web-researcher` agent

   **Example**: If 3 areas confirmed, create 12 files total (4 per area).

---

### PART 2: Build Shared Appendices

5. **Evidence Index**

   **Write**: `@todo/<folder-name>/research/evidence-index.md`
   **Content**: Consolidated list of all evidence IDs from all area-specific appendices

6. **Risks**

   **Write**: `@todo/<folder-name>/research/risks.md`
   **Content**: Consolidated list of all risks from all area-specific appendices

---

### PART 3: Cross-Area Synthesis (Main research.md)

7. **Synthesize main research.md considering ALL tech areas**

   **Structure**:
   ```markdown
   # Appendix A: Codebase Survey

   ## A.1 Current Architecture
   [Synthesized overview from all repo agents]
   - Component boundaries and organization
   - Data flow patterns
   - State management approach
   - Directory structure

   ## A.2 File-by-File Analysis
   [Combine all agent file findings, organized by area]

   ### trips/ Feature
   - mobile-app/src/app/features/trips/trip-service.ts:94-120
     - Pattern: DIP with injected client
     - Code: [full context sample]

   [Continue for all relevant files from all agents]

   ## A.3 Established Conventions
   [Patterns observed across all agents]
   - Naming conventions
   - File organization patterns
   - Testing patterns observed
   - Error handling patterns
   - Styling approach (Tamagui tokens, etc.)

   ## A.4 Integration Points
   [Where new code fits, from all agents]
   - Where new code should live
   - What existing code may need modification
   - Provider/context integration points
   - Dependency considerations
   ```

   **Target**: ~300-500 lines
   **Purpose**: Plan agent needs full codebase context without re-researching

5. **Synthesize Appendix B: Framework & API Documentation**

    **Combine findings from ALL docs-related agents:**
    - app-framework-docs-researcher
    - [specialized doc agents if used]

    **Write**: `@todo/<folder-name>/research/appendix-b-framework-docs.md`

    **Structure**:
    ```markdown
    # Appendix B: Framework & API Documentation

    ## B.1 Relevant Framework APIs
    [By framework: Relay, React Native, Expo, Tamagui]

    ### Relay APIs
    - usePaginationFragment(fragmentDef, fragmentRef)
      - Purpose: [from docs]
      - Signature: [complete signature]
      - Example: [official example]

    [Continue for all relevant APIs from docs]

    ## B.2 Best Practices & Patterns
    [Idiomatic approaches from official docs]
    - Fragment colocation pattern
    - Performance optimization techniques
    - Anti-patterns to avoid

    ## B.3 Performance Considerations
    [From docs + web research]
    - Benchmarks and metrics
    - Optimization techniques
    - Known pitfalls

    ## B.4 Production Examples
    [Real-world usage from web research]
    - Case study: Daily Bonfire (60% loading improvement)
    - Case study: Meta Horizon (production scale)
    ```

    **Target**: ~300-500 lines
    **Purpose**: Plan agent has framework knowledge without re-fetching

6. **Synthesize Appendix E: Evidence Index**

    **Consolidate ALL evidence from ALL agents:**

    **Write**: `@todo/<folder-name>/research/appendix-e-evidence-index.md`

    **Structure**:
    ```markdown
    # Appendix E: Evidence Index

    ## E.1 Repository Evidence
    [From all repo analysis agents]

    | ID | File/Location | Finding | Confidence |
    |----|---------------|---------|------------|
    | REPO-01 | supabase/types/graphql/generated/schema.graphql:810-869 | Relay-compatible schema exists | 0.95 |
    | REPO-02 | mobile-app/src/app/features/trips/trip-service.ts:94-120 | DIP pattern with injected client | 0.95 |

    [Continue for all REPO-XX citations]

    ## E.2 Framework Documentation
    [From app-framework-docs-researcher]

    | ID | Source | Topic | URL | Date | Key Claim | Confidence |
    |----|--------|-------|-----|------|-----------|------------|
    | DOCS-01 | Relay Official | useFragment | relay.dev/docs | 2024 | Fragment colocation pattern | 0.95 |

    [Continue for all DOCS-XX citations]

    ## E.3 Clean Code Analysis
    [From app-clean-code-analyzer]

    | ID | Issue Type | Location | Severity | Confidence |
    |----|-----------|----------|----------|------------|
    | CLEAN-01 | Manual cache management | trip-service.ts:94 | High | 0.90 |

    [Continue for all CLEAN-XX citations]

    ## E.4 Web Research
    [From app-web-researcher]

    | ID | Source Type | Title | URL | Pub Date | Key Claim | Confidence |
    |----|-------------|-------|-----|----------|-----------|------------|
    | WEB-01 | Blog Post | Daily Bonfire Performance | [url] | 2024-01 | 60% loading improvement | 0.85 |

    [Continue for all WEB-XX citations]
    ```

    **Target**: ~400-600 lines (mostly tables)
    **Purpose**: Complete citation trail for plan agent

7. **Synthesize Appendix F: Risks & Troubleshooting**

    **Combine risks from all agent types:**
    - Technical risks (repo + framework agents)
    - Quality risks (clean code agents)
    - Adoption risks (web research agents)

    **Write**: `@todo/<folder-name>/research/appendix-f-risks-troubleshooting.md`

    **Structure**:
    ```markdown
    # Appendix F: Risks & Troubleshooting

    ## F.1 Detailed Risk Analysis
    [5-8 risks from all agents + your synthesis]

    ### Risk 1: Relay Learning Curve
    **Description**: Team unfamiliar with Relay concepts (fragments, Suspense, compiler)
    **Likelihood**: Medium
    **Impact**: High (could delay implementation)
    **Detection**:
    - Implementation takes longer than estimated
    - Confusion about fragment colocation
    - Suspense boundary issues
    **Mitigation**:
    1. Start with small component (TripCard) before full list
    2. Pair program initial implementation
    3. Reference Daily Bonfire case study [WEB-19]
    **Fallback**: Gradual migration - keep REST endpoints alongside Relay
    **Evidence**: [WEB-33, CLEAN-06]

    [Continue for all risks]

    ## F.2 Common Issues & Solutions
    [From framework docs + web research]

    ### Issue: Relay Compiler Errors
    **Symptom**: `Error: Unknown type "trip"`
    **Cause**: Schema path incorrect in relay.config.js
    **Solution**:
    ```javascript
    module.exports = {
      schema: './supabase/types/graphql/generated/schema.graphql',
    }
    ```
    **Evidence**: [WEB-23]

    [Continue for 7+ common issues]

    ## F.3 Testing Considerations
    [From clean code + framework docs]

    ### What Needs Testing
    - Fragment composition correctness
    - Pagination behavior (loadNext, hasNext)
    - Cache updates on mutations
    - Error boundary behavior

    ### Testing Strategy
    - Use relay-test-utils for fragment tests
    - Mock RelayEnvironment for integration tests
    - Follow existing test patterns from codebase [CLEAN-07]

    ### Edge Cases to Cover
    - Empty list state
    - Network errors during pagination
    - Stale data handling
    ```

    **Target**: ~300-400 lines
    **Purpose**: Plan agent anticipates and addresses issues proactively

---

### PART 2: Synthesize From Appendices (Extract High-Level Insights)

**Now that agent findings are organized in appendices, synthesize higher-level insights:**

8. **Extract Key Findings (5-7 critical discoveries)**

   **Read through Appendices A, B, E, F to identify most important findings:**
   - What exists in the codebase that we can leverage? (scan Appendix A)
   - What patterns are established that we should follow? (scan Appendix A.3)
   - What constraints limit our options? (scan Appendices A, B, F)
   - What opportunities can we exploit? (scan Appendices A, B)

   For each finding:
   - **Discovery**: State what you found clearly
   - **Evidence**: Reference appendix sections [see Appendix A.2, REPO-XX]
   - **Implication**: Explain what this means for solution space

   **Example**:
   ```markdown
   ### Finding 1: GraphQL Schema Exists
   **Discovery**: Production-ready Relay-compatible schema at
   `supabase/types/graphql/generated/schema.graphql:810-869`
   **Evidence**: See Appendix A.2 for complete file analysis, Appendix E.1 for REPO-01
   **Implication**: Can use Relay without schema work; reduces setup complexity
   ```

9. **Write Analysis & Synthesis section**

   **Connect findings to the problem with narrative, citing appendices:**
   - **Current State**: How does codebase handle similar problems? (reference Appendix A.1, A.3)
   - **Constraints & Opportunities**: What limits us? What can we leverage? (reference Appendices A, B, F)
   - **Design Principles**: What should guide our solution? (reference Appendix A.3)

   This is sensemaking - not just listing facts, but explaining what they mean.

   **Example**:
   ```markdown
   The Container/Display pattern (detailed in Appendix A.3) is consistently
   applied across the codebase. This suggests any solution should maintain
   this separation...
   ```

10. **Create Solution Space (3-4 options at mid-to-high level)**

    For each option:
    - **Core Idea**: 1-2 sentence explanation
    - **Approach Overview**: High-level strategy (not implementation steps)
    - **Key Trade-offs**: 3-5 pros and 3-5 cons **citing appendix evidence**
    - **Complexity**: XS/S/M/L/XL
    - **Best When**: Conditions that make this the right choice

    ⚠️ **IMPORTANT**: Keep all options at the same level of detail.
    Do NOT go deep on one option yet. That happens in plan phase.

    **Example trade-off with appendix citation**:
    ```markdown
    ✅ Pros:
    - Leverages existing GraphQL schema [Appendix A.2, REPO-01]
    - Fragment colocation aligns with Container/Display pattern [Appendix A.3]
    - Production-validated at scale [Appendix B.4, WEB-19: 60% improvement]

    ❌ Cons:
    - Requires infrastructure setup [Appendix F.1: learning curve risk]
    - Steeper learning curve than alternatives [Appendix B.2]
    ```

    ❌ **Do not include in options**:
    - Step-by-step implementation plans
    - Detailed code examples
    - Configuration files
    - Troubleshooting playbooks

    ✅ **Do include in options**:
    - High-level approach and strategy
    - Key components, patterns, and external dependencies
    - Integration approach (conceptual)
    - Trade-offs with appendix evidence

11. **Score options using weighted criteria**

    Use standard weights (adjust if task needs different priorities):
    - Clean Code & Maintainability: 0.40
    - Idiomatic Expo/RN/Tamagui: 0.30
    - Fit with Existing Codebase: 0.20
    - Risk/Complexity: 0.10

    For each option, score each criterion (0-10):
    - Cite evidence from appendices [Appendix A.3, REPO-XX, DOCS-XX, etc.]
    - Show raw score and weighted score
    - Calculate total weighted score

    Present in table format (will be copied to Appendix C).

12. **Generate Recommendation**

    Choose the highest-scoring option (or use judgment if close):
    - **Why this option wins**: Key reasons based on findings + analysis (cite appendices)
    - **Trade-offs accepted**: What we're giving up
    - **Key risks**: High-level only (3-5 bullets, reference Appendix F for details)
    - **Confidence**: High/Medium/Low with rationale
    - **Next step**: Clearly state "User decision required"

    ⚠️ **Do NOT over-commit**: Research recommends, doesn't decide.

---

### PART 3: Complete Synthesis-Dependent Appendices

**Now that synthesis is complete, build appendices that depend on it:**

13. **Synthesize Appendix C: Decision Context**

    **From your scoring and analysis work** (steps 10-12):

    **Write**: `@todo/<folder-name>/research/appendix-c-decision-context.md`

    **Structure**:
    ```markdown
    # Appendix C: Decision Context

    ## C.1 Detailed Comparison Matrix
    [Complete table with all options × all criteria]

    | Option | Clean Code (0.40) | Idiomatic (0.30) | Fit (0.20) | Risk (0.10) | Total |
    |--------|-------------------|------------------|------------|-------------|-------|
    | Option A | 8/10 (3.2) [REPO-01] | 9/10 (2.7) [DOCS-03] | 10/10 (2.0) | 9/10 (0.9) | 8.8 |
    | Option B | 9/10 (3.6) [CLEAN-02] | 9/10 (2.7) [WEB-15] | 8/10 (1.6) | 6/10 (0.6) | 8.5 |

    [Continue for all options with evidence citations]

    ## C.2 Rejected Options Analysis
    [Why each non-recommended option was rejected]

    ### Option A: React Query + REST
    **Why rejected**: While faster to implement (scored 7.2), doesn't leverage
    existing GraphQL schema [REPO-01] and creates manual cache management burden
    [CLEAN-01]. Would be viable if: (a) GraphQL schema didn't exist, or (b)
    team had no capacity for Relay learning curve.

    [Continue for each rejected option]

    ## C.3 Trade-off Deep Dive
    [Detailed analysis of critical trade-offs]

    ### Speed vs. Scalability
    Option A ships in 2 hours, Option B takes 5-7 days. However, Option B
    provides 60% loading time improvement long-term [WEB-19] and eliminates
    manual cache invalidation [CLEAN-01].

    [Continue for key trade-offs]
    ```

    **Target**: ~200-300 lines
    **Purpose**: Plan agent understands WHY this option was chosen

14. **Synthesize Appendix D: Implementation Context**

    **Combine from repo analysis + clean code agents:**
    - app-repo-surveyor (integration points)
    - app-clean-code-analyzer (refactors)
    - Your synthesis (migration strategy)

    **Write**: `@todo/<folder-name>/research/appendix-d-implementation-context.md`

    **Structure**:
    ```markdown
    # Appendix D: Implementation Context

    ## D.1 Code Examples (Extended)
    [More complete than main text - 30-50 line samples]

    ### Current State: Trip Service Pattern
    ```typescript
    // mobile-app/src/app/features/trips/trip-service.ts:94-120
    export async function getUserTrips(
      supabaseClient: SupabaseClient<Database>,
      userId: string
    ): Promise<Array<Trip & { journeys: Journey[] }>> {
      const { data, error } = await supabaseClient
        .from('trip')
        .select(`*, journey (*)`)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('[Trip] Failed to get trips:', error)
        throw new Error(`Failed to get trips: ${error.message}`)
      }

      return (data || []).map((trip) => ({
        ...trip,
        journeys: trip.journey || [],
        journey: undefined,
      })) as Array<Trip & { journeys: Journey[] }>
    }
    ```

    **Pattern**: DIP with injected client, manual error handling

    ### After: Relay Fragment Approach (Conceptual)
    ```typescript
    const TripCardFragment = graphql`
      fragment TripCard_trip on trip {
        id
        nodeId
        events
        goals
        created_at
        journeyCollection(first: 10) {
          edges {
            node {
              id
              origin
              destination
            }
          }
        }
      }
    `

    export function TripCard({ tripRef }: { tripRef: TripCard_trip$key }) {
      const trip = useFragment(TripCardFragment, tripRef)
      // Fully typed, automatic cache updates
    }
    ```

    [Continue with more examples showing general approach]

    ## D.2 Related Refactors
    [From app-clean-code-analyzer report]

    ### R-001: Extract TripCard Component
    **Complexity**: XS
    **Rationale**: Currently inline in TripsScreenDisplay. Extract to
    `components/TripCard.tsx` for reuse
    **Benefit**: Reusable in list view and detail view
    **Evidence**: [CLEAN-04]

    [Continue for all refactors with complexity estimates]

    ## D.3 Migration Considerations
    [Your synthesis]

    ### What Needs to Change
    - Provider stack: Add RelayProvider after SupabaseProvider
    - Trip queries: Migrate from getUserTrips to GraphQL fragments
    - Type imports: Update to use generated Relay types

    ### Backward Compatibility
    - Keep existing Supabase client for non-trip queries
    - Gradual migration: can run both systems during transition

    ### Rollout Strategy
    - Phase 1: Setup Relay infrastructure
    - Phase 2: Migrate trip list only
    - Phase 3: Expand to other features
    ```

    **Target**: ~300-400 lines
    **Purpose**: Plan agent knows how to integrate solution into codebase

---

### PART 4: Finalize Main Document

**Now write the main research.md with sections 1-7 and appendix summaries:**

15. **Write research.md with synthesis + appendix summaries**

    **Write**: `@todo/<folder-name>/research.md`

    **Template**:
    ```markdown
    # [Task Name] Research

    **EXECUTIVE SUMMARY**

    [3-5 concise paragraphs]

    - **Recommended Approach**: [Option name]
    - **Why**: [2-3 key reasons with evidence]
    - **Trade-offs**: [Main compromise accepted]
    - **Confidence**: [High/Medium/Low with brief rationale]
    - **Next Step**: User decision required - review options below

    ---

    ## 1. Problem Statement

    - **Original Task**: [What we were asked to do]
    - **Success Criteria**: [What "done" looks like]
    - **Key Questions**: [What we needed to investigate]
    - **Assumptions to Validate**: [What we thought might be true]

    ## 2. Investigation Summary

    Brief overview of research conducted:
    - **Codebase survey**: Analyzed [N] files across [features]
    - **Framework documentation**: Reviewed [frameworks] via Context7
    - **Production examples**: Researched [case studies, benchmarks]
    - **Clean code analysis**: Identified [N] improvement opportunities
    - **[Other domains]**: [Brief description]

    **Evidence collected**: [N] repo files, [M] framework docs, [K] web sources

    ## 3. Key Findings

    **Critical discoveries that shape the solution space:**

    ### Finding 1: [Title]
    - **Discovery**: [What we found]
    - **Evidence**: [REPO-01, DOCS-03]
    - **Implication**: [What this means for our options]

    ### Finding 2: [Title]
    [Same structure]

    [Continue for 5-7 key findings]

    ## 4. Analysis & Synthesis

    **Connecting findings to the problem:**

    ### Current State
    [How does the codebase handle similar problems today? What patterns are
    consistently applied? What works well vs. what's problematic?]

    ### Constraints & Opportunities
    [What fundamental constraints limit our options? What opportunities can we
    leverage? What trade-offs are inherent to this problem space?]

    ### Design Principles
    [What principles should guide our solution? How do established patterns
    inform our approach? What consistency should we maintain?]

    ## 5. Solution Space

    **Viable approaches (mid-to-high level):**

    ### Option A: [Approach Name]
    **Core Idea**: [1-2 sentence explanation]

    **Approach Overview**:
    - [High-level strategy, not implementation steps]
    - [Key components or patterns involved]
    - [Integration approach]

    **Key Trade-offs**:
    ✅ **Pros**:
    - [Benefit 1] [Evidence: REPO-XX, DOCS-XX]
    - [Benefit 2] [Evidence: WEB-XX]
    - [3-5 total]

    ❌ **Cons**:
    - [Drawback 1] [Evidence: CLEAN-XX]
    - [Drawback 2] [Evidence: WEB-XX]
    - [3-5 total]

    **Complexity**: [XS/S/M/L/XL]
    **Best When**: [Conditions that make this the right choice]

    ### Option B: [Approach Name]
    [Same structure]

    ### Option C: [Approach Name]
    [Same structure]

    [Optional: Option D if needed]

    ## 6. Recommendation

    **Recommended Approach**: Option [X] - [Name]

    **Why This Option Wins**:
    - [Reason 1 based on key findings and analysis]
    - [Reason 2 with evidence citations]
    - [Reason 3]

    **Trade-offs Accepted**:
    - [What we're giving up by not choosing other options]
    - [Risks we're taking on]

    **Key Risks** (high-level):
    - [Risk 1] - Mitigation: [Brief strategy]
    - [Risk 2] - Mitigation: [Brief strategy]
    - [Risk 3] - Mitigation: [Brief strategy]

    See [Appendix F](./research/appendix-f-risks-troubleshooting.md) for detailed risk analysis.

    **Confidence**: [High/Medium/Low]
    - Rationale: [Why this confidence level]

    ## 7. Next Steps

    **Decision Required**:
    Review the solution options above and select the approach that best
    fits project constraints and priorities.

    **Questions to Consider**:
    - [Question about constraints, e.g., "What's the timeline pressure?"]
    - [Question about priorities, e.g., "Long-term scale vs. short-term speed?"]
    - [Question about trade-offs, e.g., "Team capacity for learning?"]

    **Once Direction is Chosen**:
    Proceed to `/app:plan <folder> --option [selected]` for detailed
    implementation planning.

    The plan phase will provide:
    - Architecture diagrams and component boundaries
    - Sequenced implementation steps with complexity ratings
    - Complete code examples and configurations
    - Testing strategy and validation criteria
    - Troubleshooting playbook

    **If More Research Needed**:
    Specify areas needing deeper investigation and re-run research
    with additional agent briefs.

    ---

    ## APPENDICES

    *Detailed context for plan agent and technical deep-dive*

    ### Appendix A: Codebase Survey
    **Purpose**: Complete codebase context for plan agent

    **Summary**:
    [2-3 sentences summarizing what was found across all repo agents]

    **Key Findings**:
    - Architecture: [Brief description with key file reference]
    - Patterns: [Key patterns observed]
    - Tech stack: [Current technologies in use]
    - Gaps: [What's missing or could be improved]
    - Integration: [Where new code fits]

    **Contents** ([full details](./research/appendix-a-codebase-survey.md)):
    - A.1 Current Architecture
    - A.2 File-by-File Analysis ([N] files)
    - A.3 Established Conventions
    - A.4 Integration Points

    ---

    ### Appendix B: Framework & API Documentation
    **Purpose**: Framework knowledge without re-fetching

    **Summary**:
    [2-3 sentences summarizing framework docs reviewed]

    **Key Findings**:
    - [Framework 1]: [Key APIs and patterns]
    - [Framework 2]: [Key considerations]
    - Performance: [Key optimization insights]

    **Contents** ([full details](./research/appendix-b-framework-docs.md)):
    - B.1 Relevant Framework APIs
    - B.2 Best Practices & Patterns
    - B.3 Performance Considerations
    - B.4 Production Examples

    ---

    ### Appendix C: Decision Context
    **Purpose**: Explain why chosen option wins

    **Summary**:
    [2-3 sentences about scoring and comparison]

    **Key Trade-offs**:
    - Chosen: [Primary trade-off accepted]
    - Rejected: [Why alternatives lost, briefly]

    **Contents** ([full details](./research/appendix-c-decision-context.md)):
    - C.1 Detailed Comparison Matrix (all options)
    - C.2 Rejected Options Analysis
    - C.3 Trade-off Deep Dive

    ---

    ### Appendix D: Implementation Context
    **Purpose**: Integration guidance for plan agent

    **Summary**:
    [2-3 sentences about integration approach]

    **Key Integration Points**:
    - [Where new code goes]
    - [What patterns to follow]
    - [Key refactors needed]

    **Contents** ([full details](./research/appendix-d-implementation-context.md)):
    - D.1 Code Examples (extended)
    - D.2 Related Refactors ([N] items)
    - D.3 Migration Considerations

    ---

    ### Appendix E: Evidence Index
    **Purpose**: Complete citation trail

    **Summary**:
    Consolidated [N total] evidence sources: [breakdown by type]

    **Coverage**:
    - Repository: [Key files]
    - Docs: [Key frameworks]
    - Web: [Key sources]
    - Analysis: [Key findings]

    **Contents** ([full details](./research/appendix-e-evidence-index.md)):
    - E.1 Repository Evidence (REPO-XX)
    - E.2 Framework Documentation (DOCS-XX)
    - E.3 Clean Code Analysis (CLEAN-XX)
    - E.4 Web Research (WEB-XX)

    ---

    ### Appendix F: Risks & Troubleshooting
    **Purpose**: Anticipate issues for plan phase

    **Summary**:
    [2-3 sentences about risk profile]

    **Risk Profile**:
    - High impact: [Key risk with mitigation]
    - Medium impact: [Key risks]
    - Low impact: [Minor risks]

    **Contents** ([full details](./research/appendix-f-risks-troubleshooting.md)):
    - F.1 Risk Analysis ([N] risks with likelihood/impact/mitigation)
    - F.2 Common Issues & Solutions ([N] documented)
    - F.3 Testing Considerations
    ```

    **Target**: ~1000-1500 lines total

16. **Update index.md**

    Add research outputs to artifacts list:
    ```markdown
    ## Artifacts
    - `index.md` - Task definition
    - `research.md` - Research findings with synthesis and appendix summaries
    - `research/` - Detailed appendices (6 files)
    ```

17. **Commit changes**

    ```bash
    git add todos/<folder-name>/research.md todos/<folder-name>/research/ todos/<folder-name>/index.md
    git commit -m "research: complete parallel research for <task-name>

    - Conducted parallel research with [N] specialized agents
    - Synthesized findings into dual-audience document
    - Sections 1-7: Human-readable synthesis and options
    - Appendices A-F: Complete context for plan phase
    - Recommendation: [brief summary]"
    ```

## Agent Research Briefs (Templates)

### app-repo-surveyor Brief
```
Task: [What we're researching]

Focus on:
- Files related to [domain/feature]
- Current patterns for [specific aspect]
- Component architecture around [area]
- State management in [context]
- Identify opportunities for [improvement]

Return your findings in your final message to the orchestrator.
Include file paths, line numbers, and code samples with full context.
```

### app-framework-docs-researcher Brief
```
Task: [What we're researching]

Fetch documentation for:
- Expo: [topics like routing, navigation, SDK modules]
- React Native: [topics like components, hooks, performance]
- Tamagui: [topics like tokens, variants, theming]

Priority topics:
1. [Topic 1]
2. [Topic 2]
3. [Topic 3]

Return your findings in your final message to the orchestrator.
Include API signatures, examples, and best practices from official docs.
```

### app-clean-code-analyzer Brief
```
Task: [What we're researching]

Analyze code quality in:
- [Component/area 1]
- [Component/area 2]
- [Component/area 3]

Look for:
- Component size issues
- Hook violations
- Type safety gaps
- Duplication patterns
- Missing error handling

Return your findings in your final message to the orchestrator.
Include specific file locations, severity ratings, and improvement suggestions.
```

### app-web-researcher Brief
```
Task: [What we're researching]

Search for:
- "[task] react native 2025"
- "[task] expo best practices"
- "[task] production experience"
- Recent migration stories
- Performance benchmarks

Focus on 2024-2025 sources from:
- Official blogs (Expo, React Native, Tamagui)
- Engineering blogs (companies using these stacks)
- Expert developer articles
- Conference talks

Return your findings in your final message to the orchestrator.
Include URLs, publication dates, key claims, and confidence ratings.
```

### Specialized Agent Briefs (Examples)

```
app-routing-analyzer:
- Analyze navigation patterns and route structure
- Identify routing-related improvements

app-state-management-analyzer:
- Survey state management approach (Context, Zustand, etc.)
- Identify state-related patterns and issues

app-performance-profiler:
- Identify performance bottlenecks
- Suggest optimization opportunities

app-security-analyzer:
- Review security implications of approach
- Identify potential vulnerabilities

app-accessibility-analyzer:
- Audit a11y compliance
- Suggest accessibility improvements
```

## Important Notes

### Parallel Execution
- **CRITICAL:** Launch all agents in a SINGLE message with multiple Task tool calls
- This enables true parallel execution (2-6x faster depending on agent count)
- Do NOT launch agents sequentially across multiple messages

### Dynamic Agent Selection
- Not all tasks need all agents
- Simple tasks might only need 2-3 agents (repo surveyor + framework docs + web)
- Complex tasks might need 6+ agents
- Use judgment based on task analysis
- **Scalability**: Can run 10+ agents - they synthesize into 6 appendices

### Agent Reports → Appendices (Many-to-Few)
- Multiple agents can contribute to same appendix
- Example: 5 repo agents → Appendix A (codebase survey)
- Orchestrator synthesizes related findings into coherent appendix
- Each appendix is standalone and focused

### Research Folder Benefits
- **Modularity**: Each appendix is separate file
- **Scalability**: N agents → 6 appendices (doesn't grow linearly)
- **Plan agent efficiency**: Reads only needed appendices
- **Git history**: Changes tracked per appendix
- **File size**: Main doc stays readable (~1500 lines max)

### Evidence IDs
- Each agent uses its own prefix: REPO-XX, DOCS-XX, CLEAN-XX, WEB-XX
- Keep these prefixes when synthesizing
- Helps track evidence provenance
- All consolidated in Appendix E

### Quality Standards
- Every claim should cite ≥1 evidence ID
- Weighted scores must show calculation
- Code samples must include file paths + line numbers
- Keep main text options at same detail level (mid-high)
- Appendices preserve full detail from agents

## Success Criteria

Your research is successful when:

**Parallel Execution:**
1. ✅ All relevant agents (2-6+) were launched in a single message (parallel)
2. ✅ All agent reports were received successfully

**Synthesis Quality (research.md Sections 1-7):**
3. ✅ Key findings are synthesized (5-7 critical discoveries)
4. ✅ Analysis section connects findings to problem space narratively
5. ✅ Solution space has 3-4 options at consistent mid-high level
6. ✅ Options are comparable (same level of detail for all)
7. ✅ Decision matrix has weighted scores with evidence citations
8. ✅ Recommendation is justified but not over-committed
9. ✅ Next steps clearly state user decision is required

**Appendix Completeness (research/ folder):**
10. ✅ Appendix A preserves complete codebase context from N repo agents
11. ✅ Appendix B includes framework APIs and best practices from M doc agents
12. ✅ Appendix C explains decision rationale and rejected options
13. ✅ Appendix D provides implementation context and refactors
14. ✅ Appendix E consolidates all evidence from all agents
15. ✅ Appendix F details risks, issues, and testing considerations

**Document Quality:**
16. ✅ research.md is readable as standalone synthesis (~1000-1500 lines)
17. ✅ Appendix summaries in research.md link to detailed files
18. ✅ Each appendix is focused and standalone (~200-600 lines)
19. ✅ Total output ~2800-4200 lines across 7 files
20. ✅ Every claim cites ≥1 evidence ID
21. ✅ Changes are committed to git

Research is NOT successful if:
- ❌ It jumps into step-by-step implementation (that's plan phase)
- ❌ It provides config files or architecture diagrams (plan phase)
- ❌ Options have wildly different detail levels
- ❌ Appendices are missing or incomplete (plan agent needs them)
- ❌ Agent reports are discarded instead of synthesized into appendices
- ❌ research.md exceeds ~1500 lines (should link to appendices, not inline)

## Research vs. Plan Boundary

This section clarifies what belongs in research phase vs. plan phase.

### Research Phase (This Command) Produces:

**research.md Sections 1-7 (Human-Focused Synthesis):**
- ✅ Problem understanding and context
- ✅ Key findings that matter (5-7 discoveries)
- ✅ Analysis connecting findings to solution space
- ✅ 3-4 viable solution options (mid-to-high level)
- ✅ Recommendation with rationale
- ✅ Decision prompt ("user should choose")
- ✅ Appendix summaries with links

**research/ Appendices A-F (Agent-Focused Context):**
- ✅ Complete codebase survey (files, patterns, conventions)
- ✅ Framework documentation and best practices
- ✅ Decision context (why chosen option wins)
- ✅ Implementation context (integration points, refactors)
- ✅ Evidence trail (all citations)
- ✅ Risk analysis and troubleshooting prep

**What Research Does NOT Include:**
- ❌ Architecture diagrams
- ❌ Sequenced implementation steps
- ❌ Complete, paste-ready code examples
- ❌ Configuration files
- ❌ Detailed testing plans
- ❌ Step-by-step migration guides

### Plan Phase (Next Command) Produces:

**Input**: `research.md` + `research/` appendices + user's selected option

**Output**: Detailed implementation plan including:
- ✅ Architecture diagrams and component boundaries
- ✅ Sequenced implementation steps (with complexity ratings)
- ✅ Complete, paste-ready code examples
- ✅ Configuration files and setup scripts
- ✅ Testing strategy with specific test cases
- ✅ Detailed troubleshooting playbook
- ✅ Validation checklist and success criteria

**What Plan Does NOT Need to Do:**
- ❌ Re-research the codebase (uses Appendix A)
- ❌ Re-fetch framework docs (uses Appendix B)
- ❌ Justify the chosen approach (uses Appendix C)
- ❌ Figure out integration points (uses Appendix D)
