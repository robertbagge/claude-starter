---
argument-hint: <research-doc-1> [research-doc-2] [research-doc-3]
description: Compare 1-3 research documents on quality dimensions
---

# compare-research

**Comparative Research Quality Analysis**

Analyzes and compares 1-3 research documents across 8 quality dimensions, providing scores, insights, and actionable recommendations for improvement.

## When to Use This Command

Use this command to:
- Compare different research approaches for the same task
- Evaluate quality of research before proceeding to planning
- Identify best practices across research documents
- Learn from comparing sequential vs parallel research methods
- Make informed decisions about which approach to adopt
- Document trade-offs between different research strategies

## Usage

```bash
# Compare single document (quality assessment only)
/compare-research @todos/2025-01-20-task/research.md

# Compare two documents
/compare-research @todos/2025-01-20-task-v1/research.md @todos/2025-01-20-task-v2/research.md

# Compare three documents
/compare-research @todos/2025-01-20-v1/research.md @todos/2025-01-20-v2/research.md @todos/2025-01-20-v3/research.md
```

## Workflow

### Phase 1: Read & Parse Documents

**YOU (the orchestrator) must:**

1. **Read all provided research documents**
   - Use Read tool for each document path
   - Extract full content from main research.md
   - **Check if `research/` folder exists** at the same level as research.md
     - If it exists, use Glob to find all markdown files: `research/*.md`
     - Read all markdown files in the research/ folder in full
     - Combine main research.md content + all research/ folder content for analysis
   - Track structure type: "single-file" or "modular (research.md + research/ folder)"

2. **Parse each document to identify:**
   - **Task/Problem**: What problem is being solved?
   - **Recommendation**: What solution is recommended?
   - **Structure**: How is the document organized?
   - **Sections**: What major sections exist?
   - **Evidence count**: Approximate number of sources cited
   - **File size**: Line count (rough indicator of depth)
   - **Research method**: Can you detect the method? (sequential, parallel agents, manual, etc.)

3. **Create document metadata summary**
   ```markdown
   Document 1: @todos/2025-01-20-task-v1/research.md
   - Task: [Brief description]
   - Recommendation: [Option name/approach]
   - Structure: [single-file | modular (research.md + research/ folder)]
   - Sections: [Key sections]
   - Evidence: ~[N] sources
   - Size: ~[N] lines total (main: [N], appendices: [N] if modular)
   - Method: [Detected method if apparent]

   [Repeat for each document]
   ```

### Phase 2: Analyze Each Document

**For each document, score on 8 dimensions (0-10 scale):**

Analyze each dimension systematically, providing:
- **Score**: 0-10 with decimal precision
- **Justification**: Why this score (2-3 sentences)
- **Evidence**: Specific examples from the document
- **Strengths**: What it does well (2-4 bullets)
- **Weaknesses**: What could improve (2-4 bullets)

**Analysis Dimensions:**

#### Dimension 1: Completeness & Coverage (0-10)

**What to Evaluate**:
- Does it address all aspects of the task?
- Are assumptions explicitly stated and validated?
- Are constraints identified?
- Are success criteria defined?
- Are all key questions answered?

**Scoring Rubric**:
- **9-10**: Comprehensive, addresses all aspects, no gaps
- **7-8**: Mostly complete, minor gaps only
- **5-6**: Significant aspects covered, some notable gaps
- **3-4**: Major gaps, several aspects missing
- **0-2**: Incomplete, many critical aspects missing

**Evidence to Look For**:
- ✅ Explicit problem statement
- ✅ Success criteria defined
- ✅ Assumptions listed and validated
- ✅ Constraints documented
- ✅ All questions from task answered
- ⚠️ Missing sections or shallow coverage

**Example Strengths**:
- "Comprehensive task interpretation with success criteria"
- "Explicitly validates all assumptions against codebase"
- "Addresses both functional and non-functional requirements"

**Example Weaknesses**:
- "Missing accessibility considerations"
- "Assumptions stated but not validated"
- "Doesn't address testing strategy"

---

#### Dimension 2: Evidence Quality & Rigor (0-10)

**What to Evaluate**:
- Are claims backed by concrete evidence?
- Is evidence properly sourced (repo files, docs, web)?
- Are file paths and line numbers provided?
- Is there a systematic evidence tracking system?
- Are confidence ratings provided?
- Is evidence recent and relevant?

**Scoring Rubric**:
- **9-10**: Rigorous evidence system, all claims cited, high confidence
- **7-8**: Good evidence tracking, most claims cited
- **5-6**: Some evidence provided, inconsistent citing
- **3-4**: Minimal evidence, many unsupported claims
- **0-2**: No evidence system, claims unsubstantiated

**Evidence to Look For**:
- ✅ Evidence IDs (e.g., REPO-01, DOCS-03, WEB-15)
- ✅ File paths with line numbers
- ✅ URLs to documentation
- ✅ Confidence ratings (0.0-1.0)
- ✅ Evidence index/table
- ✅ Publication dates for web sources
- ⚠️ Generic claims without citations
- ⚠️ Missing source attribution

**Count Evidence Sources**:
- Repository files: [N]
- Framework docs: [N]
- Web sources: [N]
- Total: [N]

**Example Strengths**:
- "60+ evidence sources with systematic IDs"
- "Every claim cites specific repo files with line numbers"
- "Evidence index with confidence ratings"

**Example Weaknesses**:
- "Only 6 sources cited"
- "Web evidence is 'aggregated' without specific URLs"
- "No confidence ratings provided"

---

#### Dimension 3: Decision Framework & Options Analysis (0-10)

**What to Evaluate**:
- Are multiple options presented?
- Is there a clear decision methodology?
- Are options scored with weighted criteria?
- Are pros/cons provided for each option?
- Is the recommendation justified with evidence?
- Are trade-offs explicitly discussed?

**Scoring Rubric**:
- **9-10**: Rigorous framework, weighted scoring, all options evaluated fairly
- **7-8**: Good framework, clear methodology, minor gaps
- **5-6**: Basic comparison, some structure
- **3-4**: Weak framework, options not compared systematically
- **0-2**: No framework, recommendation without justification

**Evidence to Look For**:
- ✅ 3-4 options presented
- ✅ Weighted criteria (e.g., Clean Code 40%, Idiomatic 30%)
- ✅ Scoring matrix/table
- ✅ Evidence citations for each score
- ✅ Trade-off discussion
- ✅ Clear recommendation with rationale
- ⚠️ Single option or no alternatives
- ⚠️ Recommendation without comparison

**Example Strengths**:
- "4 options with weighted scoring matrix"
- "Every score cites evidence (e.g., [REPO-01])"
- "Explicit trade-off analysis section"

**Example Weaknesses**:
- "Options have wildly different detail levels"
- "No scoring methodology"
- "Recommendation without justification"

---

#### Dimension 4: Actionability & Implementation Guidance (0-10)

**What to Evaluate**:
- Can someone implement from this research?
- Are code examples provided?
- Are integration points identified?
- Is there a clear next step?
- Are examples repo-aware (not generic)?

**Scoring Rubric**:
- **9-10**: Complete implementation guidance, repo-aware examples
- **7-8**: Good guidance, some examples
- **5-6**: Basic guidance, generic examples
- **3-4**: Minimal guidance, hard to implement
- **0-2**: No implementation guidance

**Evidence to Look For**:
- ✅ Code examples with file paths
- ✅ Integration points identified
- ✅ "Before/After" comparisons
- ✅ Configuration examples
- ✅ Clear next steps
- ⚠️ Generic code snippets
- ⚠️ No integration guidance
- ⚠️ Vague next steps

**Example Strengths**:
- "16-step implementation path with complexity ratings"
- "Code examples use actual repo types and imports"
- "Clear integration points identified"

**Example Weaknesses**:
- "Abstract examples without file paths"
- "No implementation steps"
- "Unclear what to do next"

---

#### Dimension 5: Structure & Navigation (0-10)

**What to Evaluate**:
- Is information logically organized?
- Can someone quickly find specific information?
- Is there a clear table of contents or sections?
- Is the document scannable?
- Are there cross-references?

**Scoring Rubric**:
- **9-10**: Excellent structure, easy to navigate, clear sections
- **7-8**: Good structure, mostly easy to find information
- **5-6**: Basic structure, some organization issues
- **3-4**: Poor structure, hard to navigate
- **0-2**: No clear structure, chaotic

**Evidence to Look For**:
- ✅ Clear section headings
- ✅ Table of contents or structure overview
- ✅ Numbered sections
- ✅ Cross-references between sections
- ✅ Appendices for detailed content
- ✅ Executive summary upfront
- ⚠️ Dense walls of text
- ⚠️ No clear organization

**Example Strengths**:
- "Modular structure with research/ folder containing detailed appendices"
- "Executive summary enables quick understanding"
- "Evidence index for cross-referencing"

**Example Weaknesses**:
- "2500 lines in single file without clear sections"
- "No table of contents"
- "Hard to find specific information"

---

#### Dimension 6: Risk Management (0-10)

**What to Evaluate**:
- Are risks identified?
- Are likelihood and impact assessed?
- Are mitigations proposed?
- Are fallback plans provided?
- Is risk ownership assigned?

**Scoring Rubric**:
- **9-10**: Comprehensive risk analysis with likelihood/impact/mitigation
- **7-8**: Good risk coverage, most have mitigations
- **5-6**: Basic risk identification
- **3-4**: Minimal risk discussion
- **0-2**: No risk analysis

**Evidence to Look For**:
- ✅ 5+ risks identified
- ✅ Likelihood ratings (High/Medium/Low)
- ✅ Impact ratings (High/Medium/Low)
- ✅ Detection methods
- ✅ Mitigation strategies
- ✅ Fallback plans
- ✅ Risk ownership assigned
- ⚠️ Generic risk statements
- ⚠️ No mitigations

**Example Strengths**:
- "5 risks with likelihood/impact/mitigation/fallback"
- "Detection methods specified for each risk"
- "Evidence citations for risk claims"

**Example Weaknesses**:
- "Only 3 generic risks"
- "No likelihood/impact assessment"
- "No mitigation strategies"

---

#### Dimension 7: Codebase Alignment (0-10)

**What to Evaluate**:
- Does it accurately reflect current codebase?
- Are existing patterns identified?
- Are file paths correct?
- Does solution fit existing architecture?
- Are imports and types accurate?

**Scoring Rubric**:
- **9-10**: Perfectly aligned, accurate analysis, repo-aware
- **7-8**: Good alignment, minor inaccuracies
- **5-6**: Basic alignment, some misunderstandings
- **3-4**: Poor alignment, several inaccuracies
- **0-2**: Disconnected from codebase reality

**Evidence to Look For**:
- ✅ Correct file paths with line numbers
- ✅ Accurate pattern identification
- ✅ Real types and imports used
- ✅ Integration points match actual architecture
- ✅ Understands existing conventions
- ⚠️ Generic examples not from codebase
- ⚠️ Incorrect file paths
- ⚠️ Misunderstands existing patterns

**Example Strengths**:
- "Correctly identifies Container/Display pattern across codebase"
- "Uses actual types from aryal-supatypes-ts"
- "Integration points match provider stack"

**Example Weaknesses**:
- "Generic React examples, not repo-specific"
- "Misunderstands current architecture"
- "File paths don't exist"

---

#### Dimension 8: Technical Depth vs. Clarity (0-10)

**What to Evaluate**:
- Is technical detail sufficient?
- Is it understandable to the target audience?
- Is complexity explained clearly?
- Are concepts introduced properly?
- Is jargon used appropriately?

**Scoring Rubric**:
- **9-10**: Perfect balance, deep but clear
- **7-8**: Good balance, minor issues
- **5-6**: Either too shallow or too complex
- **3-4**: Poor balance, hard to understand or insufficient depth
- **0-2**: Unusable due to lack of depth or clarity

**Evidence to Look For**:
- ✅ Complex concepts explained
- ✅ Code examples with comments
- ✅ Jargon defined when introduced
- ✅ Appropriate level for audience
- ✅ Progressive disclosure (summary then detail)
- ⚠️ Unexplained jargon
- ⚠️ Too much detail without context
- ⚠️ Too shallow for implementation

**Example Strengths**:
- "Deep technical detail with clear explanations"
- "Executive summary for quick understanding"
- "Progressive disclosure via appendices"

**Example Weaknesses**:
- "Too shallow, lacks implementation detail"
- "Overwhelming jargon without explanation"
- "No context for complex concepts"

---

### Phase 3: Comparative Analysis

**YOU (the orchestrator) must:**

1. **Create Scores Overview Table**

   ```markdown
   | Dimension | Doc 1 | Doc 2 | Doc 3 | Winner |
   |-----------|-------|-------|-------|--------|
   | 1. Completeness & Coverage | 9.0 | 9.5 | - | Doc 2 |
   | 2. Evidence Quality & Rigor | 8.5 | 9.5 | - | Doc 2 |
   | 3. Decision Framework | 9.0 | 9.0 | - | Tie |
   | 4. Actionability | 8.0 | 10.0 | - | Doc 2 |
   | 5. Structure & Navigation | 8.0 | 9.0 | - | Doc 2 |
   | 6. Risk Management | 7.0 | 9.0 | - | Doc 2 |
   | 7. Codebase Alignment | 9.0 | 9.5 | - | Doc 2 |
   | 8. Technical Depth vs Clarity | 8.5 | 9.0 | - | Doc 2 |
   | **TOTAL** | **67.0/80** | **74.5/80** | **-** | **Doc 2** |
   | **PERCENTAGE** | **83.8%** | **93.1%** | **-** | **Doc 2** |
   ```

2. **Identify Overall Winner**
   - Highest total score wins
   - If close (within 5%), note it's competitive
   - Explain why winner scored higher

3. **Create Key Differences Table**

   ```markdown
   | Aspect | Doc 1 | Doc 2 | Doc 3 |
   |--------|-------|-------|-------|
   | Research Method | [Method] | [Method] | - |
   | Structure Type | [single-file/modular] | [single-file/modular] | - |
   | Evidence Count | [N] sources | [N] sources | - |
   | Organization | [Description] | [Description] | - |
   | Implementation Detail | [Level] | [Level] | - |
   | Research→Plan Boundary | [Clear/Unclear] | [Clear/Unclear] | - |
   | File Size | ~[N] lines total | ~[N] lines total | - |
   ```

4. **Synthesize Strengths & Weaknesses**

   For each document:
   - List 3-5 unique strengths
   - List 3-5 key weaknesses
   - Note what it does better than others

### Phase 4: Output Report

**Write comprehensive comparison report:**

**Template**:

```markdown
# Research Quality Comparison Report

**Documents Analyzed**: [N]
**Analysis Date**: [ISO date]

---

## Executive Summary

**Overall Winner**: Document [N] ([percentage]%)

**Key Finding**: [1-2 sentences explaining most important insight from comparison]

**Score Differential**: [Brief explanation of score gap]

**Recommendation**: [Which document to use/learn from and why]

---

## Scores Overview

[Insert scores table from Phase 3]

---

## Dimension-by-Dimension Analysis

### Dimension 1: Completeness & Coverage

**Document 1**: [Score]/10
- **Justification**: [2-3 sentences]
- **Strengths**:
  - [Strength 1 with example]
  - [Strength 2 with example]
- **Weaknesses**:
  - [Weakness 1 with example]
  - [Weakness 2 with example]

**Document 2**: [Score]/10
[Same format]

**Winner**: [Document N] - [Brief explanation why]

---

[Repeat for all 8 dimensions]

---

## Key Differences

[Insert key differences table from Phase 3]

**Detailed Comparison**:

### Document 1 Unique Strengths:
- [What it does uniquely well]
- [Another unique strength]

### Document 1 Key Weaknesses:
- [What could improve]
- [Another weakness]

### Document 2 Unique Strengths:
[Same format]

### Document 2 Key Weaknesses:
[Same format]

[If Document 3 exists, repeat]

---

## Recommendations

### For Document 1:
**Improvements**:
1. [Specific actionable improvement]
2. [Another improvement]
3. [Another improvement]

**When to Use This Approach**:
- [Scenario where this approach makes sense]

### For Document 2:
[Same format]

[If Document 3 exists, repeat]

### For Future Research:
**Best Practices Identified**:
- [Practice 1 from best-performing document]
- [Practice 2]
- [Practice 3]

**Avoid**:
- [Anti-pattern from lower-scoring documents]
- [Another thing to avoid]

---

## Meta-Observations

### Research Method Insights

**[Method 1 Name]** (Document [N]):
- **Strengths**: [What this method does well]
- **Weaknesses**: [Limitations of this method]
- **Best For**: [When to use this method]

**[Method 2 Name]** (Document [N]):
[Same format]

### Trade-offs Observed

**Speed vs. Thoroughness**:
[Observation about this trade-off from comparison]

**Breadth vs. Depth**:
[Observation]

**Readability vs. Completeness**:
[Observation]

### Lessons Learned

1. [Key lesson from comparison]
2. [Another lesson]
3. [Another lesson]

---

## Conclusion

**Summary**: [2-3 sentences summarizing the comparison]

**Recommendation**: [Final recommendation on which approach to adopt or learn from]

**Next Steps**: [What to do with these insights]
```

**File to Write**: Write comparison report to output (display to user, don't write to file unless requested)

---

## Single Document Mode

If only 1 document is provided:
- Skip comparative sections
- Focus on quality assessment only
- Provide absolute scores (not relative)
- Structure report as:
  - Executive Summary (overall quality assessment)
  - Dimension scores and analysis
  - Strengths & Weaknesses
  - Recommendations for improvement
  - Overall grade (A+, A, B+, B, C+, C, D, F based on percentage)

**Grading Scale**:
- **A+ (95-100%)**: Exceptional quality
- **A (90-94%)**: Excellent quality
- **B+ (85-89%)**: Very good quality
- **B (80-84%)**: Good quality
- **C+ (75-79%)**: Acceptable quality
- **C (70-74%)**: Needs improvement
- **D (60-69%)**: Significant improvements needed
- **F (0-59%)**: Substantial revision required

---

## Example Output (Abbreviated)

### Executive Summary
**Overall Winner**: Document 2 (93.1%)

**Key Finding**: Document 2 demonstrates superior evidence rigor (60+ sources vs 6) and modular structure (research/ folder with 6 appendices), making it more actionable for the plan phase without re-research.

**Score Differential**: 9.3 percentage points (74.5 vs 67.0) - Document 2 wins 7 of 8 dimensions.

**Recommendation**: Use Document 2's approach (parallel agents, modular appendices) for complex research tasks. Document 1's approach (pragmatic, faster) remains viable for simpler tasks.

---

### Dimension 1: Completeness & Coverage

**Document 1**: 9.0/10
- **Justification**: Comprehensive task interpretation with success criteria. Explicit assumptions section. Critical gap identified ("base relay setup exists" but doesn't). Addresses data fetching, UI, performance, accessibility.
- **Strengths**:
  - ✅ Explicitly validates assumptions against codebase
  - ✅ Identifies critical gap mid-research (adaptive)
  - ✅ Comprehensive refactors section (R-001 through R-006)
- **Weaknesses**:
  - ⚠️ Slightly reactive (discovered Relay gap mid-research rather than upfront)

**Document 2**: 9.5/10
- **Justification**: Proactive assumption validation from codebase survey. All technical aspects covered (data, UI, testing, theming). Extensive troubleshooting section (7 common issues). Clear phased implementation path.
- **Strengths**:
  - ✅ Upfront assumption validation from codebase survey
  - ✅ More structured "Files of Interest" with full paths
  - ✅ Proactive identification of schema compatibility
- **Weaknesses**:
  - (None significant - very comprehensive)

**Winner**: Document 2 - More proactive assumption validation, better organization

---

[Continue for remaining dimensions...]

---

## Tips for Effective Comparison

1. **Read Thoroughly**: Don't skim - quality analysis requires full read. For modular formats (research.md + research/ folder), read both main document and all appendices
2. **Be Objective**: Score based on criteria, not personal preference
3. **Cite Examples**: Always back scores with specific examples from docs
4. **Look for Patterns**: Identify systematic differences in approach
5. **Consider Context**: Some approaches are better for different scenarios
6. **Be Constructive**: Weaknesses should be actionable improvement suggestions
7. **Check Your Math**: Ensure scores add up correctly
8. **Compare Fairly**: If documents have different scopes, note this. Modular formats may distribute content differently but should be judged on total quality

## Common Pitfalls to Avoid

- ❌ Scoring based on length (longer ≠ better)
- ❌ Preferring familiar approaches over objective quality
- ❌ Missing unique strengths of lower-scoring documents
- ❌ Not citing specific examples for scores
- ❌ Forgetting that different methods suit different contexts
- ❌ Focusing only on the winner (learn from all documents)
