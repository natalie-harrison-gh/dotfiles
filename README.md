# Natalie's dotfiles

Personal macOS dotfiles for the `natalieharrison` account and the
[`natalie-harrison-gh`](https://github.com/natalie-harrison-gh) GitHub account.
Supports Apple Silicon Macs only, using a native arm64 terminal and Homebrew
at `/opt/homebrew`. Provisioning stops immediately on unsupported systems or
when the terminal runs under Rosetta.

## Install

Install Apple's Command Line Tools if Git is not yet available, then clone:

```bash
xcode-select --install  # only if the Command Line Tools are missing; wait for installation
git clone https://github.com/natalie-harrison-gh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/strap
```

`script/strap` installs the Xcode Command Line Tools and Homebrew when needed,
loads `/opt/homebrew`, and applies `home/.Brewfile`, including GitHub CLI (`gh`).
It also configures Touch ID, security settings, macOS preferences, and GitHub
authentication. Run it when you are ready to provision the Mac.

To link the dotfiles without installing software or applying macOS preferences:

```bash
DOTFILES_SKIP_BREW=1 script/setup
```

Existing files are moved to `~/.dotfiles-backups/<timestamp>-<pid>/` before being
replaced. Re-running setup leaves correct links alone. Codex's global
`~/.codex/AGENTS.md` is copied as a regular file.

## Tools

These replace the common defaults — prefer the right column.

| Instead of          | Use              | Notes                                              |
| ------------------- | ---------------- | -------------------------------------------------- |
| `cat`               | `bat`            | aliased to `cat`; syntax highlight + paging        |
| `ls`                | `eza` (`l`)      | `l` = `eza -lha --no-user --color=always`          |
| `find`              | `fd`             |                                                    |
| `grep`              | `ripgrep` (`rg`) | flags in `home/.config/ripgrep/config`             |
| `cd`                | `zoxide` (`z`)   | learns your dirs; inited in `.zsh/config`          |
| terminal multiplexer | `herdr`         | primary multiplexer, prefix `C-;`                     |
| `top`               | `htop`           |                                                    |
| `git diff`          | `delta`          | pager, side-by-side (in `.gitconfig`)              |
| shell prompt        | `starship`       | config `home/.config/starship.toml`                |
| `ssh` (flaky net)   | `mosh`           | resilient mobile shell                             |

Plus core dev tools: `gh` (GitHub CLI + git credentials/auth), `direnv`
(per-dir `.envrc`), `asdf` (runtime versions from `.tool-versions`), `jq`,
and `shellcheck`. Language runtimes stay out of Homebrew and are installed
through `asdf` only when needed.

## Reinstalling AI tooling

These CLIs, runtimes, and agent skills aren't part of `script/strap` (they're
interactive and need logins). Reprovision them on demand:

```bash
brew bundle --global      # base toolchain (asdf, etc.)
install/runtimes.sh       # latest node/ruby/rust via asdf; Python via uv
install/ai.sh             # claude, codex, and agent skills
```

- **Runtimes**: `asdf` manages node/ruby/rust/uv from `home/.tool-versions`.
  **Python is uv-managed** — use `uv python`, `uv venv`, `uvx`, `uv tool install`.
- **Skills**: restored from `skills/manifest.txt` via `npx skills`. Regenerate the
  manifest from what's installed with `install/skills.sh --generate`. Personal
  skills live in `skills/custom/` (symlinked in); add one with the
  `add-dotfiles-skill` skill.
- **codex**: run `codex` once to sign in.

Moshi's hook is installed from its trusted Homebrew formula but pairing remains
an intentional, interactive step. Herdr is the only managed terminal multiplexer.

## Layout

- `home/` — dotfiles; each is symlinked into `$HOME` by `script/setup`.
- `home/.zsh/` — `config`, `aliases`, `scripts`, `autocompletion`.
- `home/.config/` — `starship.toml`, `herdr/`, `ghostty/`, `ripgrep/`.
- `install/`, `script/` — provisioning and bootstrap.

See `AGENTS.md` for how the repo works and tool-preference rules when coding here.
