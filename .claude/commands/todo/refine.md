---
argument-hint: [exact-folder-name] (optional)
description: Interactively refine task descriptions with targeted questions
---

# Refine Task

## Description

Interactively refine a todo task description by analyzing current content and asking targeted multi-select questions to gather missing details about problem context, technical specifics, and success criteria.

## Usage

```bash
/todo:refine [exact-folder-name]
```

If no folder name is provided, you'll be prompted to select from existing todos.

## Steps

### 1. Identify Todo to Refine

If `$ARGUMENTS` is provided, use that folder name. Otherwise, list available todos and ask user to select one.

```bash
sh .claude/commands/todo/scripts/list.sh
```

If listing todos, present them and ask which one to refine.

Store the selected folder name as `[folder-name]`.

### 2. Read Current Task Description

Read the current task description to analyze what information exists and what's missing:

```
Read @todos/[folder-name]/index.md
```

### 3. Analyze Content Gaps

Analyze the current task description for:
- **Problem Clarification**: Missing context about current flow, constraints, pain points, or dependencies
- **Technical Details**: Missing file paths, API endpoints, timing measurements, BAML functions, or infrastructure details
- **Success Criteria**: Unclear query patterns, extensibility requirements, or acceptance criteria
- **Approach Options**: Vague implementation approaches or missing architecture diagrams

### 4. User Decision Point

Present a summary of the current task state to the user and ask if they want to proceed with refinement:

- Show the task title and a brief summary
- Highlight major gaps or areas that could benefit from refinement
- Ask: "This task description [has good coverage / could benefit from more detail in X areas]. Would you like to proceed with interactive refinement?"

Use the `AskUserQuestion` tool with options:
- "Yes, refine it" - Proceed to step 5
- "No, it's sufficient" - Exit gracefully
- "Show me the full description first" - Display the full index.md content, then repeat this question

If user chooses not to refine, exit with a message confirming no changes were made.

### 5. Interactive Refinement Questions

Use the `AskUserQuestion` tool to gather missing information. Ask 1-4 rounds of questions based on the analysis from Step 3. Focus on the most critical gaps first.

**Question Categories:**

**A. Problem Clarification**
- What is the current implementation/flow?
- What are the specific constraints or limitations?
- What dependencies exist (data models, APIs, services)?
- What pain points or issues does this address?

**B. Technical Details**
- What are the relevant file paths for code/configs?
- What API endpoints or BAML functions are involved?
- What are the timing/performance characteristics?
- What infrastructure or tools are being used?
- What data structures are passed between components?

**C. Success Criteria**
- What are the expected query patterns?
- What extensibility requirements exist?
- What does "done" look like?
- What future considerations should be documented?

**Question Format Guidelines:**
- Use multi-select when appropriate (e.g., "Which details can you provide?")
- Include "Will provide in next message" option when specific paths/values are needed
- Include "Unknown/needs investigation" option when information isn't readily available
- Keep questions focused and actionable
- Ask follow-up questions based on previous answers

### 6. Update index.md

Based on the gathered information, update the task description in `@todos/[folder-name]/index.md`:

**Preservation Rules:**
- Keep existing section structure (Description, Assumptions, Work Artifacts, Notes)
- Preserve any existing content that's still accurate
- Enhance sections with refined information

**Enhancement Patterns:**
- If current implementation is described: Add "Current Implementation" section with subsections for Flow, Code Locations, Technical Details, Constraints
- If there are complex dependencies: Add a "Dependency Graph" section with mermaid diagram
- If multiple approaches exist: Add "Target Architecture" or "Options to Evaluate" section
- If timing/performance is critical: Add explicit timing measurements and constraints
- If extensibility matters: Add "Future Considerations" or expand "Assumptions" section

Use the `Edit` tool to make precise updates to specific sections.

### 7. Confirmation

After updating, show a brief summary of what was enhanced:
- List the sections that were added or significantly enhanced
- Mention 2-3 key details that were clarified
- Confirm the file location: `todos/[folder-name]/index.md`

## Examples

**Example 1: With folder name argument**
```bash
/todo:refine 2025-11-07-travel-plan-gen
```

**Example 2: Interactive selection**
```bash
/todo:refine
```
Then select from the list of available todos.

## Error Handling

- If provided folder name doesn't exist in `todos/`, show error and list available folders
- If `index.md` doesn't exist in the selected folder, show error
- If user cancels during any step, exit gracefully without making changes
- If Edit tool fails, show error and preserve original content
