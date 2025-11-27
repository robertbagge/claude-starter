---
adr_number: {number}
title: {Title}
date: {Date, e.g. 2025-10-22}
author: {Git user, e.g. robertbagge}
# Status options: Proposed | Accepted | Deprecated | Superseded by ADR-XXX
status: Proposed
# Tech area tags examples:
#   - Infrastructure: infrastructure, cloud, kubernetes, docker, ci-cd, deployment
#   - Backend: backend, api, microservices, messaging, caching, workers
#   - Data: database, data-model, migrations, analytics, etl, storage
#   - Frontend: frontend, ui, mobile, desktop, web, components
#   - Cross-cutting: security, performance, observability, testing, tooling, architecture
tech_area_tags:
  - backend
  - database
  - api
---

# ADR-{number}: {Title}

## Context

{1-3 paragraphs describing the problem, forces at play, and constraints. What is the issue motivating this decision?}

{Include relevant background that helps understand why this decision is necessary. What business or technical problem are we solving?}

## Decision

{1-2 paragraphs stating the architecture decision and providing rationale. Use active voice: "We will..."}

{Explain WHY this approach was chosen. Connect the decision back to the context and constraints.}

## Consequences

### Positive
- {Benefit 1}
- {Benefit 2}
- {Benefit 3}

### Negative
- {Trade-off 1}
- {Trade-off 2}

### Neutral
- {Side effect 1}
- {Side effect 2}

## Alternatives Considered

### {Alternative 1}
{Why rejected in 1-2 sentences. What made this option less suitable than the chosen decision?}

### {Alternative 2}
{Why rejected in 1-2 sentences. What made this option less suitable than the chosen decision?}

## References
- {Link to RFC, design doc, or external resource}
- {Related ADR}
- {Relevant documentation}

---

## Notes for Authors

**Common Status Values:**
- **Proposed** - Under review, not yet implemented
- **Accepted** - Approved and being/been implemented
- **Deprecated** - No longer relevant, kept for historical context
- **Superseded by ADR-XXX** - Replaced by a newer decision

**Common Tech Area Tags:**
- **Infrastructure:** infrastructure, cloud, kubernetes, docker, ci-cd, deployment
- **Backend:** backend, api, microservices, messaging, caching, workers
- **Data:** database, data-model, migrations, analytics, etl, storage
- **Frontend:** frontend, ui, mobile, desktop, web, components
- **Cross-cutting:** security, performance, observability, testing, tooling, architecture

**Tips:**
- Keep Context focused on the problem, not the solution
- Decision should be clear and actionable ("We will..." not "We might...")
- Consequences should be honest - include real trade-offs
- Alternatives show due diligence but should be brief
- Use active voice throughout
