# SPDX-License-Identifier: MIT
#!/usr/bin/env python3
"""Validate Universal Humanizer package manifests, versions, and pattern structure."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def read_file(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except OSError as err:
        sys.exit(f"Error reading {path.relative_to(ROOT)}: {err}")


def load_json(path: Path) -> dict:
    content = read_file(path)
    try:
        return json.loads(content)
    except json.JSONDecodeError as err:
        sys.exit(f"Invalid JSON in {path.relative_to(ROOT)}: {err}")


def main() -> None:
    skill_text = read_file(ROOT / "SKILL.md")
    readme_text = read_file(ROOT / "README.md")
    changelog_text = read_file(ROOT / "CHANGELOG.md")
    plugin_json = load_json(ROOT / "plugin.json")
    claude_plugin_json = load_json(ROOT / ".claude-plugin" / "plugin.json")
    claude_marketplace_json = load_json(ROOT / ".claude-plugin" / "marketplace.json")
    gemini_json = load_json(ROOT / "gemini-extension.json")

    # 1. Validate YAML Frontmatter in SKILL.md
    frontmatter_match = re.match(r"\A---\n(.*?)\n---\n", skill_text, re.DOTALL)
    if not frontmatter_match:
        sys.exit("SKILL.md must begin with valid YAML frontmatter between --- lines.")
    frontmatter = frontmatter_match.group(1)

    skill_ver_match = re.search(r'(?m)^\s+version:\s*["\']?([0-9]+\.[0-9]+\.[0-9]+)["\']?', frontmatter)
    if not skill_ver_match:
        sys.exit("SKILL.md frontmatter must declare metadata.version (e.g. version: \"1.0.0\").")
    skill_version = skill_ver_match.group(1)

    # 2. Validate versions across all manifests
    plugin_version = str(plugin_json.get("version", ""))
    claude_version = str(claude_plugin_json.get("version", ""))
    gemini_version = str(gemini_json.get("version", ""))

    changelog_ver_match = re.search(r'(?m)^## ([0-9]+\.[0-9]+\.[0-9]+)', changelog_text)
    if not changelog_ver_match:
        sys.exit("CHANGELOG.md must begin with a version heading (e.g. ## 1.0.0).")
    changelog_version = changelog_ver_match.group(1)

    all_versions = {
        "SKILL.md": skill_version,
        "plugin.json": plugin_version,
        ".claude-plugin/plugin.json": claude_version,
        "gemini-extension.json": gemini_version,
        "CHANGELOG.md": changelog_version,
    }

    unique_versions = set(all_versions.values())
    if len(unique_versions) != 1:
        sys.exit(f"Version mismatch across manifests: {all_versions}")

    version = skill_version

    # 3. Check License field in manifests
    for manifest_name, manifest in [
        ("plugin.json", plugin_json),
        (".claude-plugin/plugin.json", claude_plugin_json),
        ("gemini-extension.json", gemini_json),
    ]:
        if manifest.get("license") != "MIT":
            sys.exit(f"{manifest_name} must declare 'license': 'MIT'")

    # 4. Check pattern numbering in SKILL.md (1 to 25)
    pattern_numbers = [
        int(num) for num in re.findall(r"(?m)^#### ([0-9]+)\. ", skill_text)
    ]
    if not pattern_numbers:
        sys.exit("Could not find numbered pattern headings in SKILL.md (format: #### N. Pattern Name).")

    expected_patterns = list(range(1, len(pattern_numbers) + 1))
    if pattern_numbers != expected_patterns:
        sys.exit(
            f"Pattern numbers in SKILL.md must be sequential starting at 1 with no gaps. Found: {pattern_numbers}"
        )
    pattern_count = len(pattern_numbers)
    if pattern_count != 25:
        sys.exit(f"Expected exactly 25 patterns in SKILL.md, found {pattern_count}.")

    # 5. Check pattern table in README.md
    readme_numbers = [
        int(num) for num in re.findall(r"(?m)^\| ([0-9]+) \|", readme_text)
    ]
    if sorted(readme_numbers) != pattern_numbers:
        sys.exit(
            f"README.md pattern tables must list all {pattern_count} patterns. Found: {sorted(readme_numbers)}"
        )

    expected_title = f"## The {pattern_count} patterns"
    if expected_title not in readme_text:
        sys.exit(f"README.md must contain the section heading '{expected_title}'.")

    # 6. Check synced nested SKILL.md
    nested_skill = ROOT / "skills" / "universal-humanizer" / "SKILL.md"
    if not nested_skill.exists():
        sys.exit("Missing nested skills/universal-humanizer/SKILL.md. Run scripts/sync-skill.py.")
    if read_file(nested_skill) != skill_text:
        sys.exit("skills/universal-humanizer/SKILL.md is out of sync with root SKILL.md. Run scripts/sync-skill.py.")

    # 7. Check Claude marketplace manifest
    if claude_plugin_json.get("skills") != ["./"]:
        sys.exit(".claude-plugin/plugin.json 'skills' field must be ['/'].")

    plugins = claude_marketplace_json.get("plugins", [])
    if not plugins or plugins[0].get("name") != "universal-humanizer":
        sys.exit(".claude-plugin/marketplace.json must declare plugin 'universal-humanizer'.")

    # 8. Check prompt & command derivatives exist
    for derivative in [
        ROOT / "rules" / "humanizer.md",
        ROOT / "prompts" / "humanizer.md",
        ROOT / "commands" / "humanizer.toml",
    ]:
        if not derivative.exists():
            sys.exit(f"Missing expected derivative {derivative.relative_to(ROOT)}. Run scripts/sync-skill.py.")

    print(f"Validation successful: Universal Humanizer v{version} package is healthy ({pattern_count} patterns).")


if __name__ == "__main__":
    main()
