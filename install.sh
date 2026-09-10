# SPDX-License-Identifier: MIT
#!/usr/bin/env bash
# Universal Humanizer - Cross-Platform Multi-Agent Installer
# Safe, standalone, zero-telemetry installation script.

set -euo pipefail

REPO="irrumi/universal_humanizer"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

SCOPE="global"
TARGET_AGENT="all"
DRY_RUN=false
UNINSTALL=false

# CLI Argument Parsing
while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      SCOPE="global"
      shift
      ;;
    --project)
      SCOPE="project"
      shift
      ;;
    --agent)
      TARGET_AGENT="$2"
      shift 2
      ;;
    --all)
      TARGET_AGENT="all"
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    -h|--help)
      cat << 'EOF'
Universal Humanizer Installer
Usage: install.sh [OPTIONS]

Options:
  --global       Install globally to user configuration directories (default)
  --project      Install to current workspace/project directories
  --agent <name> Install for specific agent (antigravity, gemini, claude, codex, cursor, windsurf, opencode)
  --all          Install for all detected agents (default)
  --dry-run      Show planned installation actions without modifying any files
  --uninstall    Remove installed skill files
  -h, --help     Show this help message
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IS_LOCAL=false
if [[ -f "${SCRIPT_DIR}/SKILL.md" ]]; then
  IS_LOCAL=true
fi

# Helper: Fetch file content (from local repo or GitHub raw)
get_content() {
  local rel_path="$1"
  if [[ "${IS_LOCAL}" == true && -f "${SCRIPT_DIR}/${rel_path}" ]]; then
    cat "${SCRIPT_DIR}/${rel_path}"
  else
    curl -fsSL "${RAW_BASE}/${rel_path}"
  fi
}

install_file() {
  local rel_source="$1"
  local dest_path="$2"

  if [[ "${DRY_RUN}" == true ]]; then
    echo "  [DRY-RUN] Would write ${dest_path}"
    return 0
  fi

  local dest_dir
  dest_dir="$(dirname "${dest_path}")"
  mkdir -p "${dest_dir}"

  if [[ -f "${dest_path}" ]]; then
    cp "${dest_path}" "${dest_path}.bak"
    echo "  [BACKUP] Existing file backed up to ${dest_path}.bak"
  fi

  get_content "${rel_source}" > "${dest_path}"
  echo "  [INSTALLED] ${dest_path}"
}

remove_file() {
  local dest_path="$1"
  if [[ -f "${dest_path}" ]]; then
    if [[ "${DRY_RUN}" == true ]]; then
      echo "  [DRY-RUN] Would remove ${dest_path}"
    else
      rm -f "${dest_path}"
      echo "  [REMOVED] ${dest_path}"
      if [[ -f "${dest_path}.bak" ]]; then
        mv "${dest_path}.bak" "${dest_path}"
        echo "  [RESTORED] Restored backup to ${dest_path}"
      fi
    fi
  fi
}

echo "=================================================="
echo "    Universal Humanizer Installer (v1.0.0)"
echo "=================================================="
echo "Scope:       ${SCOPE}"
echo "Target:      ${TARGET_AGENT}"
echo "Dry run:     ${DRY_RUN}"
echo "=================================================="
echo ""

declare -a INSTALLED_AGENTS=()

# 1. Google Antigravity
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "antigravity" ]]; then
  if command -v agy &>/dev/null || [[ -d "${HOME}/.gemini" ]] || [[ "${TARGET_AGENT}" == "antigravity" ]]; then
    echo "Configuring Google Antigravity..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${HOME}/.gemini/config/skills/universal-humanizer/SKILL.md"
      remove_file "${PWD}/.agents/skills/universal-humanizer/SKILL.md"
      remove_file "${HOME}/.gemini/config/plugins/universal-humanizer/plugin.json"
      remove_file "${HOME}/.gemini/config/plugins/universal-humanizer/skills/universal-humanizer/SKILL.md"
      remove_file "${HOME}/.gemini/config/plugins/universal-humanizer/rules/humanizer.md"
    else
      if [[ "${SCOPE}" == "global" ]]; then
        install_file "SKILL.md" "${HOME}/.gemini/config/skills/universal-humanizer/SKILL.md"
        install_file "plugin.json" "${HOME}/.gemini/config/plugins/universal-humanizer/plugin.json"
        install_file "skills/universal-humanizer/SKILL.md" "${HOME}/.gemini/config/plugins/universal-humanizer/skills/universal-humanizer/SKILL.md"
        install_file "rules/humanizer.md" "${HOME}/.gemini/config/plugins/universal-humanizer/rules/humanizer.md"
      else
        install_file "SKILL.md" "${PWD}/.agents/skills/universal-humanizer/SKILL.md"
      fi
      INSTALLED_AGENTS+=("Google Antigravity (available as skill & plugin)")
    fi
  fi
fi

# 2. Gemini CLI
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "gemini" || "${TARGET_AGENT}" == "gemini-cli" ]]; then
  if command -v gemini &>/dev/null || [[ -d "${HOME}/.gemini" ]] || [[ "${TARGET_AGENT}" =~ gemini ]]; then
    echo "Configuring Gemini CLI..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${HOME}/.gemini/extensions/universal-humanizer/gemini-extension.json"
      remove_file "${HOME}/.gemini/extensions/universal-humanizer/rules/humanizer.md"
      remove_file "${HOME}/.gemini/commands/humanizer.toml"
    else
      install_file "gemini-extension.json" "${HOME}/.gemini/extensions/universal-humanizer/gemini-extension.json"
      install_file "rules/humanizer.md" "${HOME}/.gemini/extensions/universal-humanizer/rules/humanizer.md"
      install_file "commands/humanizer.toml" "${HOME}/.gemini/commands/humanizer.toml"
      INSTALLED_AGENTS+=("Gemini CLI (command /humanizer, extension loaded)")
    fi
  fi
fi

# 3. Claude Code
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "claude" || "${TARGET_AGENT}" == "claude-code" ]]; then
  if command -v claude &>/dev/null || [[ -d "${HOME}/.claude" ]] || [[ "${TARGET_AGENT}" =~ claude ]]; then
    echo "Configuring Claude Code..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${HOME}/.claude/skills/universal-humanizer/SKILL.md"
    else
      install_file "SKILL.md" "${HOME}/.claude/skills/universal-humanizer/SKILL.md"
      INSTALLED_AGENTS+=("Claude Code (skill ~/.claude/skills/universal-humanizer/)")
    fi
  fi
fi

# 4. OpenAI Codex CLI
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "codex" ]]; then
  if command -v codex &>/dev/null || [[ -d "${HOME}/.codex" ]] || [[ "${TARGET_AGENT}" == "codex" ]]; then
    echo "Configuring Codex CLI..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${HOME}/.codex/prompts/humanizer.md"
    else
      install_file "prompts/humanizer.md" "${HOME}/.codex/prompts/humanizer.md"
      INSTALLED_AGENTS+=("Codex CLI (/prompts:humanizer)")
    fi
  fi
fi

# 5. Cursor
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "cursor" ]]; then
  if command -v cursor &>/dev/null || [[ -d "${PWD}/.cursor" ]] || [[ -d "${HOME}/.cursor" ]] || [[ "${TARGET_AGENT}" == "cursor" ]]; then
    echo "Configuring Cursor..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${PWD}/.cursor/rules/humanizer.mdc"
    else
      install_file "rules/humanizer.md" "${PWD}/.cursor/rules/humanizer.mdc"
      INSTALLED_AGENTS+=("Cursor (.cursor/rules/humanizer.mdc)")
    fi
  fi
fi

# 6. Windsurf
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "windsurf" ]]; then
  if command -v windsurf &>/dev/null || [[ -d "${PWD}/.windsurf" ]] || [[ "${TARGET_AGENT}" == "windsurf" ]]; then
    echo "Configuring Windsurf..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${PWD}/.windsurf/rules/humanizer.md"
    else
      install_file "rules/humanizer.md" "${PWD}/.windsurf/rules/humanizer.md"
      INSTALLED_AGENTS+=("Windsurf (.windsurf/rules/humanizer.md)")
    fi
  fi
fi

# 7. OpenCode
if [[ "${TARGET_AGENT}" == "all" || "${TARGET_AGENT}" == "opencode" ]]; then
  if command -v opencode &>/dev/null || [[ -d "${HOME}/.config/opencode" ]] || [[ -d "${PWD}/.opencode" ]] || [[ "${TARGET_AGENT}" == "opencode" ]]; then
    echo "Configuring OpenCode..."
    if [[ "${UNINSTALL}" == true ]]; then
      remove_file "${HOME}/.config/opencode/skills/universal-humanizer/SKILL.md"
      remove_file "${PWD}/.opencode/skills/universal-humanizer/SKILL.md"
    else
      if [[ "${SCOPE}" == "global" ]]; then
        install_file "SKILL.md" "${HOME}/.config/opencode/skills/universal-humanizer/SKILL.md"
      else
        install_file "SKILL.md" "${PWD}/.opencode/skills/universal-humanizer/SKILL.md"
      fi
      INSTALLED_AGENTS+=("OpenCode (skills/universal-humanizer/SKILL.md)")
    fi
  fi
fi

echo ""
echo "=================================================="
if [[ "${UNINSTALL}" == true ]]; then
  echo "Universal Humanizer uninstallation complete."
else
  echo "Installation complete! Activated environments:"
  for agent in "${INSTALLED_AGENTS[@]}"; do
    echo "  * ${agent}"
  done
  echo ""
  echo "How to invoke:"
  echo "  - In chat: /humanizer [paste your text]"
  echo "  - Or ask: 'Please humanize this text according to universal humanizer guidelines'"
fi
echo "=================================================="
