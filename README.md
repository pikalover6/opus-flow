# Opus Flow

An isolated Claude Code workflow experiment.

- **Opus 4.8 High** owns the task and orchestrates.
- **Opus 4.8 XHigh** handles the initial planning pass and replans.
- **Sonnet 5 Medium** does most implementation.
- **Haiku 4.5** handles bounded research and CLI bridges.
- **GPT-5.5 High** is rare outside counsel through Codex.
- **Codex review** is available through OpenAI's official Claude Code plugin.
- **Codex image generation** is available when a product genuinely needs custom visual assets.

The experiment is session-scoped. `opus-flow` loads the workflow; plain `claude` stays plain.

## Install on macOS

```bash
curl -fsSL https://raw.githubusercontent.com/pikalover6/opus-flow/main/install.sh | bash
exec zsh
```

The installer:

- clones Opus Flow to `~/.local/share/opus-flow`
- clones OpenAI's Codex Claude Code plugin to `~/.local/share/opus-flow-deps/codex-plugin-cc`
- installs the Codex CLI with npm if it is missing
- creates `~/.local/bin/opus-flow`
- adds `~/.local/bin` to your zsh `PATH` if needed

It does **not** copy agents, skills, rules, or settings into `~/.claude`.

## First run

From any project:

```bash
cd ~/code/my-project
opus-flow
```

Inside Claude Code, check Codex once:

```text
/codex:setup
```

If Codex needs authentication:

```text
!codex login
```

## Normal workflow

For a new project or substantial feature:

1. Enter Claude Code **Plan mode**.
2. Run:

```text
/opus-flow:kickoff Build ...
```

3. Review the plan.
4. Exit Plan mode and say:

```text
Execute the approved plan.
```

The kickoff turn runs Opus 4.8 at XHigh effort. Normal orchestration then returns to Opus 4.8 High.

During execution, Opus Flow can:

- fan out read-only Haiku scouts
- delegate ordinary implementation to Sonnet 5 Medium builders
- run independent writers in isolated worktrees when the baseline is committed
- use Opus 4.8 Low for narrow, unusually subtle changes
- consult GPT-5.5 High when an independent second opinion could change the answer
- request image generation for justified frontend assets

For a major rethink:

```text
/opus-flow:rethink
```

Before shipping:

```text
/opus-flow:ship-check main
```

The ship check verifies the work and, when useful, tells you which Codex review command to run. Examples:

```text
/codex:review --background --base main
/codex:adversarial-review --background --base main challenge the auth boundaries and rollback safety
```

## Vanilla Claude Code

Just run:

```bash
claude
```

No Opus Flow agents or workflow settings are loaded by that command.

## Update

Run the install command again:

```bash
curl -fsSL https://raw.githubusercontent.com/pikalover6/opus-flow/main/install.sh | bash
```

It fast-forwards both local checkouts and refreshes the launcher.

## Uninstall

```bash
rm -rf ~/.local/share/opus-flow \
       ~/.local/share/opus-flow-deps/codex-plugin-cc \
       ~/.local/bin/opus-flow
```

This does not uninstall Claude Code or the Codex CLI.

## Commands

| Command | Purpose |
|---|---|
| `/opus-flow:kickoff <task>` | XHigh planning pass for substantial work |
| `/opus-flow:rethink` | XHigh replan when assumptions break or attempts fail |
| `/opus-flow:ship-check [base]` | Verify the outcome and choose the right review gate |

## Agent topology

```text
Opus 4.8 High orchestrator
├── Haiku scout
├── Sonnet 5 Medium builder
│   └── Haiku scout when tightly scoped
├── Sonnet 5 Medium worktree builder
├── Opus 4.8 Low surgeon
├── Haiku → GPT-5.5 High consultant
└── Haiku → Codex image generation
```

Parallel writers are capped at three. The orchestrator owns integration and adjudicates all reviewer findings.

## Development

Clone the repo and load it directly:

```bash
git clone https://github.com/pikalover6/opus-flow.git
cd opus-flow
claude --plugin-dir .
```

To test with the official Codex plugin too:

```bash
claude \
  --plugin-dir . \
  --plugin-dir ~/.local/share/opus-flow-deps/codex-plugin-cc/plugins/codex
```

After editing plugin files in a running session:

```text
/reload-plugins
```
