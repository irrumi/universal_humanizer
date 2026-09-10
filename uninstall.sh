# SPDX-License-Identifier: MIT
#!/usr/bin/env bash
# Universal Humanizer - Uninstaller
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "${SCRIPT_DIR}/install.sh" ]]; then
  bash "${SCRIPT_DIR}/install.sh" --uninstall "$@"
else
  curl -fsSL "https://raw.githubusercontent.com/irrumi/universal_humanizer/main/install.sh" | bash -s -- --uninstall "$@"
fi
