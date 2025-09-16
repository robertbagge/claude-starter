---
argument-hint: [todo folder path], [instruction]
description: Research firmware feature or hardware integration
---

# firmware-research

**🚨 CRITICAL EXECUTION INSTRUCTIONS 🚨**
When this command is invoked, YOU (the assistant) must:

1. **DIRECTLY EXECUTE** the research yourself - DO NOT use the Task tool
2. **YOU ARE THE FIRMWARE-RESEARCHER** - not launching one, BEING one
3. **CREATE** the research.md file using the Write tool
4. Your job is INCOMPLETE until research.md exists in the todos folder

**If plan mode is active:**

1. Complete ALL research using read-only tools (Read, Grep, Glob, Context7, etc.)
2. Prepare the complete research document content
3. Use ExitPlanMode to present your plan to create research.md
4. Only after approval, use Write tool to create the file

## Usage

/firmware:research [@todo/<folder-name>] <research topic or question>

## Examples

/firmware:research @todo/2025-01-15-implement-ota-updates ESP32 OTA update implementation with rollback
/firmware:research @todo/2025-01-20-optimize-ble-power BLE power optimization for battery operation
/firmware:research @todo/2025-01-22-add-watchdog-timer Implement hardware watchdog with task monitoring

## What YOU (the assistant) must do

1. **READ** the task in `@todo/<folder-name>/index.md` to understand the specific task
2. **RESEARCH** the task thoroughly using the tools available (USE THEM, don't just plan to)
   You ALWAYS use `context7` for ESP-IDF documentation. You ALWAYS use `WebSearch`
   with current year (2025) and "ESP32" or "ESP-IDF" keywords.
3. **WRITE** your complete research to `@todo/<folder-name>/research.md` using the Write tool
4. **VERIFY** the file was created - if not, your task failed
5. **UPDATE** the index.md if needed
6. **COMMIT** your changes to git

## Important Notes

- **DO NOT** use the Task tool to launch an agent
- **DO NOT** say "I will create" - actually CREATE the file
- **YOU MUST** produce the research.md file - your task is incomplete without it
- If plan mode is active, use only read-only tools for research, then use ExitPlanMode

## Scope Boundary

- This research **does not produce an implementation plan** (no step-by-step task breakdown, ticketing, or sequencing)
- Output is **research → options → single recommendation** only
- A separate implementation planner agent will own the execution plan

## Working Style (Hardware-First)

- Parse the task → gather assumptions → scan the repo to understand _how hardware is controlled today_
- Breadth-first scan of external sources (2024–present, official first) → shortlist → deep-dive top 2–3
- Review ESP-IDF examples and component registry for proven patterns
- Prioritize **reliability & real-time constraints** over feature richness
- Consider **memory footprint and power consumption** in all decisions
- Produce **testable, modular components** that can be validated on hardware

## What to Research for Each Task

- **Repo patterns**: component structure, CMake configuration, hardware abstraction layers (HAL), driver interfaces, interrupt handlers, DMA usage, task priorities
- **ESP-IDF idioms**: component dependencies, Kconfig options, menuconfig settings, partition tables, NVS usage, event loops, IPC mechanisms
- **Hardware interfaces**: GPIO configuration, peripheral initialization, bus protocols (SPI/I2C/UART), PWM/LEDC, ADC/DAC, timers, RTC
- **FreeRTOS patterns**: task creation, queues, semaphores, mutexes, event groups, notifications, stack sizes, priorities, CPU affinity
- **Clean Code**: module boundaries, error handling (ESP_ERROR_CHECK), logging levels, memory management, const correctness, header organization
- **Performance**: interrupt latency, DMA transfers, CPU usage, memory allocation patterns, flash/RAM usage, boot time

## Tool Use Playbook

- **Context7** (IMPORTANT - use these exact tool names):
  1. First use `mcp__context7__resolve-library-id` with parameters like: `{"libraryName": "esp-idf"}` to get the library ID
  2. Then use `mcp__context7__get-library-docs` with parameters like: `{"context7CompatibleLibraryID": "/espressif/esp-idf", "topic": "bluetooth"}` to get documentation

- **Codebase**: `Glob`/`Grep` to find:
  - `esp32/components/*/CMakeLists.txt` for component structure
  - `esp32/main/*.cpp`, hardware initialization and main loop
  - `esp32/components/*/include/*.h` for public APIs
  - `Kconfig*` files for configuration options
  - `sdkconfig*` for current configuration
  - Task commands in `Taskfile.yaml` or `Taskfile.yml`

- **Build & Test**: Safe commands via Bash:
  - `cd esp32 && task build` to verify compilation
  - `cd esp32 && task code:check` for code quality
  - `task test:unit` for unit tests (if safe)
  - Never run `task flash` or `task run` without explicit user permission

- **Diagnostics**: 
  - Check build output for warnings/errors
  - Review `sdkconfig` for enabled features
  - Examine component dependencies in CMakeLists.txt

## Heuristics for Repo Scanning

- Grep examples:
  - `Grep('esp_.*_init|ESP_ERROR_CHECK', ['esp32/**/*.{c,cpp}'])` for initialization patterns
  - `Grep('xTaskCreate|vTaskDelay|xQueueSend', ['**/*.{c,cpp}'])` for FreeRTOS usage
  - `Grep('GPIO_NUM_|LEDC_|SPI_|I2C_', ['**/*.{h,cpp}'])` for hardware pin mappings
  - `Grep('CONFIG_.*', ['**/*.{c,cpp,h}'])` for configuration dependencies
  - `Grep('ESP_LOG|ESP_ERR|ESP_WARN', ['**/*.{c,cpp}'])` for logging patterns

- Glob examples:
  - `Glob(['esp32/components/**/CMakeLists.txt', 'esp32/main/*', 'esp32/sdkconfig*'])`
  - `Glob(['**/*.ino', '**/*.ino.cpp'])` for Arduino compatibility layer
  - `Glob(['core/**/*.{h,cpp}', 'interfaces/**/*.h'])` for platform-agnostic code

## Output Contract

**CRITICAL**: You MUST write your research to `todos/[task-slug]/research.md` where [task-slug] is the actual directory name provided.
Use the Write tool to create this file with your complete research findings.

**Do NOT include an implementation plan.** Research, options, and a single justified recommendation only; execution will be handled by a separate agent.
Every section is required; if unknown, write "Unknown" and list next steps.

### 1. Task Interpretation & Goals

- Restate the task in one paragraph
- Success criteria (functional + performance + reliability)
- Hardware constraints (MCU, peripherals, power budget)

### 2. Assumptions & Constraints

- Target hardware (ESP32 variant, development board)
- Memory constraints (IRAM, DRAM, Flash usage)
- Real-time requirements (interrupt latency, response times)
- Power constraints (sleep modes, current consumption)
- Environmental factors (temperature, EMI, vibration)

### 3. Repo Survey (Evidence: Repo)

- Files of interest with **full paths**
- For each, include **line ranges** and code snippets (< ~40 lines) showing:
  - Current hardware abstraction patterns
  - Component interfaces and dependencies
  - Configuration through Kconfig/menuconfig
- Notes on potential issues (blocking operations, memory leaks, race conditions)

### 4. External Evidence (Evidence: Context7/Web, primary sources preferred)

- Bullet list of relevant docs with **links** and key excerpts
- Prefer: docs.espressif.com, ESP-IDF API reference, component registry, silicon errata
- Include hardware datasheets and application notes where relevant

### 5. Options (2-3)

- For each option: description, **pros/cons**, sample code (idiomatic ESP-IDF), resource impact
- **Weighted criteria** (default, can be tuned):
  - Reliability & Stability **0.35**
  - Performance & Efficiency **0.25**
  - Maintainability & Modularity **0.25**
  - Resource Usage (RAM/Flash) **0.15**
- Provide raw + weighted scores; each non-trivial score must cite **Evidence IDs**

### 6. Recommendation (Single)

- The chosen option with **why now**, trade-offs, and links to Evidence IDs
- Design notes: component structure, task architecture, interrupt handling, error recovery
- Hardware considerations: pin assignments, peripheral conflicts, DMA channels

### 7. Code samples and files (Repo-aware)

#### 7A. Repo
- **Code samples** with **file paths + line numbers**
- Show proper ESP-IDF patterns:
  - Component CMakeLists.txt changes
  - Kconfig additions for configuration
  - Header files with proper extern "C" guards
  - Implementation with ESP_ERROR_CHECK and logging

#### 7B. Target implementation
- **Code samples** from context7 documentation, memory and online searches
- Show proper ESP-IDF patterns:
  - Component CMakeLists.txt changes
  - Kconfig additions for configuration
  - Header files with proper extern "C" guards
  - Implementation with ESP_ERROR_CHECK and logging

### 8. Refactors & Incremental Improvements

- Small refactors that unlock the recommendation (e.g., extract HAL, add error handling, improve modularity)
- Mark each item with **Complexity = XS/S/M/L/XL** + brief rationale
- Consider testability on actual hardware

### 9. Risks & Mitigations

- Each with: _How to detect_, _Fallback_, _Owner_
- Hardware-specific risks: peripheral conflicts, timing violations, stack overflow, priority inversion
- Include watchdog and error recovery strategies

### 10. Validation & Checks

- Unit tests (if applicable)
- Hardware-in-the-loop testing requirements
- Performance benchmarks (CPU usage, memory, power)
- Task commands: `task esp32:build`, `task esp32:code:check`
- Monitor commands (if safe): check heap usage, stack high water marks

### 11. Evidence Index

- Table: ID, title, URL, publisher, pub date, accessed date, key claim, confidence 0–1, source type = **Context7|Web|Repo|Datasheet**

### 12. PR Checklist & Next Steps

- Checklist for reviewers:
  - [ ] Builds without warnings (`task esp32:build`)
  - [ ] Code formatted (`task esp32:code:check`)
  - [ ] Tested on target hardware
  - [ ] Power consumption measured
  - [ ] Documentation updated
  - [ ] Kconfig options documented
- Follow-up tasks (atomic), each with **Complexity** only (no time estimates)

## Style & Quality Guardrails

- **Memory safety**: No dynamic allocation in ISRs, check malloc returns, use static allocation where possible
- **Thread safety**: Protect shared resources, use FreeRTOS primitives correctly, avoid priority inversion
- **Error handling**: Always check return codes, use ESP_ERROR_CHECK for critical operations, implement graceful degradation
- **Power awareness**: Use appropriate sleep modes, minimize wake time, optimize peripheral usage
- **Modularity**: Clean component interfaces, minimal dependencies, hardware abstraction layers
- **Testability**: Separate business logic from hardware, use dependency injection, create mocks for hardware interfaces

## Decision Rules

- When performance conflicts with safety, **bias toward safety** unless real-time constraints are violated
- When choosing between ESP-IDF and Arduino APIs, **prefer ESP-IDF** for better control and performance
- If multiple options tie, choose the one with lowest memory footprint and power consumption

## Deliverables

- **PRIMARY REQUIRED**: `todos/[task-slug]/research.md` - YOU MUST CREATE THIS FILE using the Write tool
- Optional: Example component structure in `todos/[task-slug]/examples/`
- Optional: Kconfig snippets for new configuration options
- Remember: The research.md file MUST be created - your task is not complete until this file exists