# SPDX-License-Identifier: MIT
#!/usr/bin/env python3
"""Sync root SKILL.md to derivative agent configurations across formats."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILL_FILE = ROOT / "SKILL.md"


def read_file(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def sync_nested_skill(skill_content: str) -> None:
    nested_path = ROOT / "skills" / "universal-humanizer" / "SKILL.md"
    write_file(nested_path, skill_content)
    print(f"[OK] Synced {nested_path.relative_to(ROOT)}")


def generate_rules_file(skill_content: str) -> None:
    # Strip YAML frontmatter
    body = re.sub(r"\A---\n.*?\n---\n", "", skill_content, flags=re.DOTALL)
    header = (
        "# Universal Humanizer Writing Guidelines\n\n"
        "> These rules guide style, tone, rhythm, and clarity. Always preserve factual correctness.\n\n"
    )
    rules_path = ROOT / "rules" / "humanizer.md"
    write_file(rules_path, header + body.strip() + "\n")
    print(f"[OK] Generated {rules_path.relative_to(ROOT)}")


def generate_codex_prompt(skill_content: str) -> None:
    body = re.sub(r"\A---\n.*?\n---\n", "", skill_content, flags=re.DOTALL)
    frontmatter = (
        "---\n"
        "description: Rewrite AI-sounding text to sound natural, varied, and human\n"
        "argument-hint: [PROSE=<text-to-rewrite>] [FILE=<path>]\n"
        "---\n\n"
    )
    prompt_path = ROOT / "prompts" / "humanizer.md"
    write_file(prompt_path, frontmatter + body.strip() + "\n")
    print(f"[OK] Generated {prompt_path.relative_to(ROOT)}")


def generate_gemini_command() -> None:
    toml_content = (
        'description = "Rewrite AI-sounding text into natural human prose without altering facts"\n'
        'prompt = """\n'
        'Please rewrite the following text according to Universal Humanizer principles:\n'
        '- Remove staged contrasts (not X, but Y), dramatic one-line closers, and phantom debates.\n'
        '- Eliminate repetitive triplets, excessive em dashes, and overused AI buzzwords.\n'
        '- Introduce varied sentence lengths (burstiness) and ensure natural flow.\n'
        '- Preserve every verifiable fact, number, date, and name without hallucinating new details.\n'
        '\n'
        '{{args}}\n'
        '"""\n'
    )
    cmd_path = ROOT / "commands" / "humanizer.toml"
    write_file(cmd_path, toml_content)
    print(f"[OK] Generated {cmd_path.relative_to(ROOT)}")


def main() -> None:
    skill_content = read_file(SKILL_FILE)
    sync_nested_skill(skill_content)
    generate_rules_file(skill_content)
    generate_codex_prompt(skill_content)
    generate_gemini_command()
    print("All derivative configurations synchronized successfully.")


if __name__ == "__main__":
    main()
