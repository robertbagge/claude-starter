---
argument-hint: [todo folder path], [description]
description: Research BAML
---

# BAML research command

Research BAML-related topics using specialized agent with comprehensive tools.

## Usage

```shell
/baml:research <todo folder to work on> <research description>
```

## Description

This command delegates BAML research tasks to the baml-prompt-engineer agent,
which will use:

- WebSearch for recent documentation and tutorials
- context7 MCP tools for official library documentation
- WebFetch for specific documentation pages
- Other relevant tools as needed

## Parameters

- `description` (required): The research task or topic to investigate

## Examples

```shell
/baml:research best practices for error handling in BAML prompts
/baml:research how to structure complex data extraction prompts
/baml:research BAML function composition patterns
```

## Implementation

```javascript
const description = args.join(" ");

if (!description) {
  return "Error: Please provide a research task description\nUsage: /baml:research <description>";
}

await assistant.runAgent("baml-prompt-engineer", {
  prompt: `Research the following BAML-related topic using all available resources:

Task: ${description}

Please use the following tools as appropriate:
1. WebSearch - for finding recent BAML documentation, tutorials, and best practices
2. context7 MCP tools (resolve-library-id and get-library-docs) - for official library documentation
3. WebFetch - for retrieving specific documentation pages
4. Any other relevant tools for comprehensive research

Provide:
- Key findings and insights
- Relevant code examples or patterns
- Best practices and recommendations
- Links to useful resources
- Links to codebase files that are relevant
- Any limitations or considerations

Focus on practical, actionable information that would help with BAML prompt engineering tasks.`,
});
```

## Output

Write your out to `baml-research.md` in the todo folder you are working in. Make sure to also update the `index.md` file in the todo folder with your Work Artifact.
