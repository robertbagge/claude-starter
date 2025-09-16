---
argument-hint: [todo folder path], [description]
description: Research scientific topics
---

# Science research command

Research scientific topics and academic literature using specialized agent with comprehensive tools.

## Usage

```shell
/science:research <todo folder to work on> <research description>
```

## Description

This command delegates scientific research tasks to the scientific-prompt-researcher agent,
which will use:

- WebSearch for recent scientific papers and academic publications
- WebFetch for specific research articles and documentation
- Academic databases and repositories
- Other relevant tools as needed

## Parameters

- `todo_folder` (required): The todo folder path to work in (e.g., `todos/2025-01-21T14-30-00-research-task/`)
- `description` (required): The scientific research task or topic to investigate

## Examples

```shell
/science:research todos/2025-01-21T14-30-00-memory-research/ spaced repetition algorithms in cognitive science
/science:research todos/2025-01-21T15-00-00-medical-analysis/ evidence-based approaches for symptom analysis
/science:research todos/2025-01-21T16-45-00-ml-research/ recent advances in transformer architectures
```

## Implementation

```javascript
const [todoFolder, ...descriptionParts] = args;
const description = descriptionParts.join(" ");

if (!todoFolder || !todoFolder.startsWith("todos/")) {
  return "Error: Please provide a valid todo folder path\nUsage: /science:research <todo folder> <description>";
}

if (!description) {
  return "Error: Please provide a research task description\nUsage: /science:research <todo folder> <description>";
}

// Read the todo folder contents to understand context
let todoContext = "";
try {
  const indexPath = `${todoFolder}/index.md`;
  const indexContent = await assistant.read(indexPath);
  todoContext = `\n\nExisting Todo Context from ${indexPath}:\n${indexContent}`;
} catch (e) {
  // Index file may not exist yet
}

try {
  const descriptionPath = `${todoFolder}/description.md`;
  const descriptionContent = await assistant.read(descriptionPath);
  todoContext += `\n\nTask Description from ${descriptionPath}:\n${descriptionContent}`;
} catch (e) {
  // Description file may not exist
}

// Check for any existing research or notes
try {
  const files = await assistant.ls(todoFolder);
  if (files.length > 0) {
    todoContext += `\n\nExisting files in todo folder: ${files.join(", ")}`;
  }
} catch (e) {
  // Folder may not exist yet
}

await assistant.runAgent("scientific-prompt-researcher", {
  prompt: `Research the following scientific topic using all available academic resources:

Working Directory: ${todoFolder}
Research Request: ${description}
${todoContext}

Please use the following tools as appropriate:
1. First, read any existing files in the todo folder to understand the full context
2. WebSearch - for finding recent academic papers, peer-reviewed studies, and scientific literature
3. WebFetch - for retrieving specific research papers and academic documentation
4. Any other relevant tools for comprehensive scientific research

Provide:
- Key scientific findings with citations
- Empirical evidence and research methodology
- Relevant theories and frameworks
- Statistical data and experimental results
- Links to primary sources and papers
- Limitations and areas for future research
- Practical applications of the research

Focus on peer-reviewed, evidence-based information from authoritative scientific sources.

Output Requirements:
- Write your findings to '${todoFolder}/science-research.md'
- Update '${todoFolder}/index.md' with a summary of your research
- Include proper academic citations in APA or similar format
- Organize findings by theme or chronology as appropriate`,
});
```

## Output

The agent will write research findings to:
- `science-research.md` in the specified todo folder with comprehensive research findings
- Update `index.md` in the todo folder with a summary and key insights

Research output will include:
- Literature review with citations
- Key scientific concepts and theories
- Empirical evidence and data
- Methodology considerations
- Practical applications
- Future research directions