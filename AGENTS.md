# Dotfiles Repository Instructions

This is a modular dotfiles management system forked from cowboy/dotfiles, designed for cross-platform shell environment configuration. It's personalized for me, Taylor Braun-Jones.

## Architecture Overview

**Core Bootstrap Script**: `bin/dotfiles` is the main orchestrator that:
1. Installs Git if needed (via apt/brew)
2. Clones/updates the repo to `~/.dotfiles`
3. Executes files from `init/`, `copy/`, and `link/` directories in sequence
4. Backs up conflicting files to timestamped `backups/` directory

**Modular Shell Configuration**: Uses a two-tier loading system following canonical Unix/Linux shell initialization:

- `profile.d/*.sh` - Sourced once on login shells (environment variables, PATH setup)
- `bashrc.d/*.sh` - Sourced on every interactive shell (aliases, functions, prompt, completions)

**Shell Initialization Flow**:

```text
Login shells (WSL2, SSH, terminal login):
  ~/.bash_profile
    ├─> ~/.profile (sources profile.d/*.sh for environment)
    └─> ~/.bashrc (sources bashrc.d/*.sh for interactive features)
          └─> Returns early if non-interactive

Non-login interactive shells (subshells, `bash` command):
  ~/.bashrc (only)
    └─> Sources bashrc.d/*.sh
```

**Critical Separation**:

- **profile.d/**: Login-once configuration (PATH, environment variables, umask). Avoid interactive features.
- **bashrc.d/**: Interactive shell features (aliases, functions, prompt, bash completion). Never modify PATH here.

**File Naming Convention**: Use numeric prefixes to control load order:

- `00-09`: Core setup (e.g., `00setup.sh` for utility functions)
- `10-49`: System/language-specific config (e.g., `10pixi.sh`, `50git.sh`)
- `50-89`: Tool-specific configurations
- `99`: Final cleanup/theming (e.g., `99starship.sh`)

## Key Patterns

**Conditional Loading**: All configs check for tool existence before setup:
```bash
if ! type git &>/dev/null; then
    return
fi
```

**Cross-Platform Compatibility**: OS detection in init scripts:
```bash
# Ubuntu-only
if ! type apt &> /dev/null; then return; fi

# macOS-only  
[[ "$OSTYPE" =~ ^darwin ]] || return 1
```

**Safe Aliasing**: Use `maybe_alias` function from `00setup.sh` to conditionally create aliases only when executables exist.

## Development Workflow

**Adding New Configurations**:

1. Add tool-specific setup to `bashrc.d/50toolname.sh` (interactive features) or `profile.d/50toolname.sh` (PATH/environment)
2. Add installation logic to appropriate `init/10_platform.sh`
3. Use `~/.dotfiles/bin/dotfiles` to test changes

**Custom Utilities**: Add executable scripts to `bin/` (automatically added to PATH). See `bin/eachdir` for multi-directory operations pattern.

**External Dependencies**: Manage as git submodules in `libs/` directory (e.g., `libs/rbenv/`, `libs/z/`).

**Personal Configuration**: Files requiring personal data go in `copy/` (copied once), while generic configs go in `link/` (symlinked for live editing).

## Important Files

- `bashrc.d/00setup.sh` - Core utility functions (`maybe_alias`, `path_remove`)
- `link/.bashrc` - Entry point that sources bashrc.d for interactive features
- `link/.bash_profile` - Login shell entry that sources .profile then .bashrc
- `link/.profile` - Sources profile.d for environment setup
- `conf/firsttime_reminder.sh` - First-run instructions
- `bin/dotfiles` - Main bootstrap/update script

When adding tool support, follow the existing pattern: check availability, set up environment, add aliases/functions, and ensure cross-platform compatibility.
