# Claude Starter

This repo includes a number of resources for safe and productive coding with AI
agents, currently focusing on Claude Code. Key resources are:

- Claude Code setup with
  - Key commands for todo-management and agent triggers
  - _(Coming soon)_ A handful of useful agent definitions
  - Some default MCP servers
  - CLAUDE.md
- A devcontainer to create a safe environment for agentic coding.

## Cloning the repo

This repo uses submodules. To clone, please use
`git clone --recursive https://github.com/robertbagge/claude-starter.git`

To update the repo and the modules, use `git pull --recurse-submodules`

## Key resources

### Claude code setup

The claude code setup aims to bring a lot of good defaults for being productive
with claude code. It is based on these key principles:

1. Context engineering is key - each task should have a tailored context
   for that task.
2. Work is done through subagents and commands
3. Context is gathered in files rather than in claude cli memory

#### Getting started with Claude Code

1. Copy the following folders/files to your repo

- [.claude](./.claude)
- [CLAUDE.md](./CLAUDE.md)
- [.mcp.json](./.mcp.json)

1. Make sure to setup a env with necessary API tokens for Claude Code and MCP
   servers to work. See [.env.example](./.env.example). Be careful with
   important secrets though as we can't guarantee claude's behaviour.

After this you are ready to run `claude "prompt"` and start coding. I often
start with `claude "do nothing"` to not have claude start taking actions
immediately. You can verify the setup by running `/status` to see that
the MCP servers are installed etc.

the `/doctor`, `/permissions`
and `agents` commands to see that the permissions and agents are setup.

1. Create your first todo with `/todo:create <task description>`
   and get coding.

#### Tools & techniques

##### Research - Planning - Coding pattern

At the moment the pattern of splitting tasks into a research stage, a planning
stage and a coding stage is quite popular. Each of these stages starts with a
clear claude code context and reads/save context from files.

This ensures that each stage just get exactly what it needs to perform a task
to high quality.

> This approach also consumes significantly less tokens
> than ongoing prompting.

##### Todo tool

To facilitate context gathering there is a small todo tool with three commands
included.

- `/todo:create <description>`
- `/todo:list`
- `/todo:complete <folder-path>`

You can then instruct prompt agents and commands with the task and instructions
to save their context there for other agents to pick up, pure prompt example:

> You are technical researcher working on @todos/2025-09-03T10-00-00-auth0-to-clerk.
>
> There is existing auth-logic with auth0 in the codebase. Find those hotspots
> and gather them in a list. Also includes some code samples.
>
> For the new implementation we want to keep it very clean. Make sure any
> recommendations are following these guidelines
> <https://github.com/robertbagge/clean-code/tree/main/react>.
> For researching clerk. use context7.
>
> You are to gather resources, identifying issues and coming up with recommendations.
> You are not creating an implementation plan.
> Gather all your findings in @todos/2025-09-03T10-00-00-auth0-to-clerk/research.md
> Also add this prompt to the top of that document and make sure the file index in
> @todos/2025-09-03T10-00-00-auth0-to-clerk/research.md is updated.
>
> Create a git commit when you are done with your research.

#### CLAUDE.md

The CLAUDE.md is kept tiny as it is included in every context. Guidelines
should be provided through commands, subagent definitions and prompts.

#### Commands

See [.claude/commands](./.claude/commands/) for a full list of commands.

#### Agents

### Agent definitions will be added soon

#### MCP servers

See [.mcp.json] for a list of default MCP servers.

#### Modifications

Update commands, agents, mcp-servers, CLAUDE.md etc as you see fit.

### Devcontainer

The devcontainer setup aims to create a safe environment for agentic coding.
It includes a number of base packages and programming languages as well
as a firewall that whitelists safe domains.

Coding in a devcontainer with a strong firewall means you can relax agent
permissions without having to worry that it might access other things on
your filesystem or the Internet.

#### Getting started with Devcontainer

1. Copy the .devcontainer to wherever you want it
2. Make modifications as required
3. Open your repo in the devcontainer in your IDE

- [VSCode](https://code.visualstudio.com/docs/devcontainers/containers)
- [JetBrains](https://www.jetbrains.com/help/idea/connect-to-devcontainer.html)

1. Authenticate to CLI tools that claude needs access to

- Github CLI - `gh auth login` and `gh auth setup-git`
- Claude itself unless you have an api key

#### Devcontainer Modifications

##### **1. Add a new language or tool**

If there is an asdf-vm plugin. Search for "asdf X plugin",
e.g. "asdf python plugin"

- Add the dependency to [.devcontainer/.tool-versions](./.devcontainer/.tool-versions)
- Add the plugin to [.devcontainer/Dockerfile](./.devcontainer/Dockerfile)

If there is not an asdf-vm plugin. Add installation in Dockerfile.
`apt-get` is preferred if supported. Otherwise use alternative install method.
See installation of `markdownlint-cli2` and `lychee` for example.

##### **2. Update firewall**

You might need to whitelist more domains to support your organization,
dev environment and MCP-servers.

Do so by updating the [.devcontainer/init-firewall.sh](./.devcontainer/init-firewall.sh)
script. Certain domains uses CDNs and other proxies that updates
the IPs frequently. These require a bit more setup.

For tooling I advice doing all installation as part of the container setup
rather than at runtime as there are no firewall rules then.

##### **3. Modify startup script**

Different requirements requires different startup commands to load
the environment properly. Modify the `postCreateCommand` and `postStartCommand`
in [.devcontainer/devcontainer.json](./.devcontainer/devcontainer.json)
to your needs.

##### **4. IDE extensions**

The base setup comes with a bunch of VSCode extension that are pre-installed.
You can remove/add extensions as you see fit. For VSCode theme/ui extensions
are the same as on your local machine.

For Jetbrains example see -
<https://github.com/JetBrains/devcontainers-examples/blob/main/customizations/plugins/.devcontainer.json>

## Development Guidelines

### Set up dev environment

#### In devcontainer

No additional setup needed

#### On local

##### Install tools

- [asdf-vm](https://asdf-vm.com/)
- [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
- [lychee](https://github.com/lycheeverse/lychee)

```bash

asdf plugin add task ## (Optional if you don't have the plugin already)
asdf install
```

### Available commands

```bash
## Runs on PRs
task ci
```

For other available commands run

```bash
task list
```
