# Contributing to Universal Humanizer

Thank you for your interest in improving Universal Humanizer! We welcome contributions from developers, technical writers, and prompt engineers.

---

## Architecture & Single Source of Truth

Universal Humanizer is built as a portable, cross-platform agent skill:
- **`SKILL.md`** is the **single source of truth** for all core prompt logic, pattern definitions, and editorial methodology.
- Derivative configuration files (`skills/universal-humanizer/SKILL.md`, `rules/humanizer.md`, `prompts/humanizer.md`, `commands/humanizer.toml`) are generated automatically. **Never edit derivative files by hand.**

---

## Ways to Contribute

We welcome contributions across several areas:
1. **Agent Integrations & Adapters:** Adding support for new AI coding tools, IDEs, or CLI assistants.
2. **Pattern Refinements:** Sharpening pattern definitions (1–25) or adding realistic, verified counter-examples.
3. **Bilingual Improvements:** Refining Russian and English pattern examples and eliminating emerging AI idioms.
4. **Installer Improvements:** Enhancing `install.sh` or `install.ps1` for edge cases in different OS distributions or shell setups.
5. **Documentation & Voice Samples:** Adding domain-specific writing sample templates in `assets/`.

---

## Development Workflow

### 1. Clone Repository
```bash
git clone https://github.com/irrumi/universal_humanizer.git
cd universal_humanizer
```

### 2. Make Edits
Make your prompt edits exclusively in `SKILL.md`.

### 3. Synchronize Derivatives
Run the synchronization script to propagate changes across all agent formats:
```bash
python3 scripts/sync-skill.py
```

### 4. Run Test & Validation Suite
Run the test suite to verify that manifest versions, pattern numbering (1 to 25), and JSON/YAML structures remain healthy:
```bash
python3 scripts/validate-package.py
```

If you have `claude` CLI and Node.js installed, you can also run:
```bash
claude plugin validate .
npx --yes skills@1.5.25 add . --list
```

### 5. Submit Pull Request
Push your changes to a feature branch and open a pull request against `main`. All PRs must pass the automated GitHub Actions validation workflow.

---

## Ground Rules

- **Factual Fidelity Guidance:** The skill must never encourage hallucinating facts, metrics, or citations.
- **Strict Version Synchronization:** If bumping versions, ensure `SKILL.md`, `plugin.json`, `.claude-plugin/plugin.json`, `gemini-extension.json`, and `CHANGELOG.md` all share the identical semantic version.
- **Preserve Code & Data:** Prompt updates must maintain safeguards preventing AI agents from modifying code blocks, tables, URLs, or frontmatter metadata during file-level rewrites.

For AI subagent contribution guidelines, see [AGENTS.md](AGENTS.md).
