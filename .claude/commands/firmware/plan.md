---
argument-hint: [todo folder path], [instruction]
description: Plan Firmware feature
---

# firmware-planning

Read an existing research package and produce a concrete, sequenced, dependency-aware implementation plan for an ESP-IDF/C/C++ firmware codebase. **No timelines or time estimates.** Research is a key input, and the task description also informs the plan. May supplement gaps with Context7 docs and web sources when needed.

## Usage

/firmware:plan [@todo/<folder-name>] <plan topic or question>

## Examples

/firmware:plan @todo/2025-01-15-lamp-demo-routine
/firmware:plan @todo/2025-01-20-mqtt-integration

## Workflow

When this command is executed:

1. Parse `research.md`, `index.md`, `architecture.md` as well as linked GitHub issues or Jira Tickets → extract scope, constraints, components of interest, best practices.
2. Make high-level plan in phases e.g -> 1. Hardware abstraction layer 2. Communication protocol 3. Application logic, etc.
3. Break down each phase in smaller steps with clear hardware/software boundaries
4. Emit `plan.md`, update `index.md` with status/artifacts.

## DO

1. Produce phases and steps describing the work that is planned
2. Focus on hardware/software integration and real-time constraints
3. Inspect documentation with context7 mcp if necessary. Especially ESP-IDF, FreeRTOS, and hardware component datasheets
4. Read existing firmware patterns and HAL abstractions in the codebase
5. Reference tools used on codebase e.g. `task`, `idf.py`, `cmake`
6. Consider memory constraints, power consumption, and real-time requirements
7. Include hardware validation steps

## DO NOT

1. Care about time estimates, operational metrics or complexity measures
2. Create sub-tickets
3. Reference tools not used in codebase, e.g. `make` (unless in CMakeLists), `platformio`
4. Ignore hardware constraints or real-time requirements

## Plan Template

**Note:** The phases below are illustrative. Adapt to your feature - a simple GPIO control might only need one phase, while complex sensor integration might need several.

```markdown
# Implementation Plan: [Feature Name]

## Overview
[Brief summary from research.md including hardware components involved]

## Prerequisites
[Hardware requirements, IDF components, libraries, pin configurations if needed]

## Phase 1: [Hardware Abstraction/Driver Layer]
### Objective
[What hardware capability this exposes to higher layers]

### Context from Research
```c
// Pattern examples from codebase
// Include relevant code samples with file:line references
// Hardware initialization sequences
```

### Steps
1. **Component initialization** - Hardware peripheral setup and configuration
2. **Driver interface** - Abstract API for hardware control
3. **Interrupt handling** - ISR setup and event processing
4. **Error detection** - Hardware fault detection and recovery

### Acceptance Criteria
- [Hardware responds correctly to commands]
- [Timing requirements met]
- [Power consumption within spec]
- [Error conditions handled gracefully]

## Phase 2: [Protocol/Communication Layer]
### Objective
[What communication capability this adds - UART, I2C, SPI, WiFi, BLE, etc.]

### Steps
1. **Protocol implementation** - Message framing and parsing
2. **Buffer management** - DMA setup and circular buffers if needed
3. **Flow control** - Hardware/software handshaking
4. **Error recovery** - Timeout handling and retransmission

### Acceptance Criteria
- Messages transmitted and received correctly
- Throughput meets requirements
- Robust against noise/disconnection
- Memory usage optimized

## Phase 3: [Application Logic]
### Objective
[What user-facing or system functionality this delivers]

### Steps
1. **State machine** - Application states and transitions
2. **Task scheduling** - FreeRTOS task priorities and timing
3. **Event handling** - Inter-task communication via queues/semaphores
4. **Data persistence** - NVS or filesystem storage if needed
5. **System tests** - End-to-end functionality validation

### Acceptance Criteria
- [System behavior matches requirements]
- [Real-time deadlines met]
- [Resource usage within limits]

## Hardware Considerations
- Pin assignments and conflicts
- Power domains and sleep modes
- Clock configurations
- Memory layout (IRAM, DRAM, Flash)
- Bootloader requirements

## Patterns from Research
[List key patterns discovered, with references to codebase examples and ESP-IDF components used]
```