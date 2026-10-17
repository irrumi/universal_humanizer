"""Offline checks of reviewed documentation, not a model or semantic evaluator."""
import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
PAIR = re.compile(
    r'- \*\*Before \((EN|RU)\):\*\*\s*(.*?)\n'
    r'- \*\*After \(\1\):\*\*\s*(.*?)(?=\n- \*\*Before|\n\n|\Z)', re.S
)


def skill_pairs(text):
    pairs = {}
    for section in re.split(r'(?m)^#### ', text)[1:]:
        number = int(section.split('.', 1)[0])
        for match in PAIR.finditer(section):
            pairs[f'skill-{number:02}-{match[1].lower()}'] = (
                match[2].strip(), match[3].strip()
            )
    return pairs


class PublishedExamples(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cases = json.loads((ROOT / 'evals/published-examples.json').read_text())
        cls.skill = (ROOT / 'SKILL.md').read_text()
        cls.readme = (ROOT / 'README.md').read_text()

    def test_every_skill_pair_matches_review(self):
        actual = skill_pairs(self.skill)
        expected = {c['id']: (c['input'], c['output']) for c in self.cases
                    if c['id'].startswith('skill-')}
        self.assertEqual(len(expected), 44)
        self.assertEqual(actual, expected)

    def test_every_readme_pair_matches_review(self):
        cases = {c['id']: c for c in self.cases}
        quick = re.search(r'\| \*\*Input \(AI Draft\)\*\* \| \*"(.*?)"\* \|', self.readme)[1]
        output = re.search(r'\| \*\*Human Rewrite\*\* \| \*\*"(.*?)"\*\* \|', self.readme)[1]
        self.assertEqual((quick, output), (cases['readme-quick']['input'], cases['readme-quick']['output']))
        for lang, before, after in [('en', 'Before (AI-Generated Draft)', 'After (Universal Humanizer)'),
                                    ('ru', 'До (Типичный ИИ-текст)', 'После (Universal Humanizer)')]:
            match = re.search(r'\*\*' + re.escape(before) + r':\*\*\n> (.*?)\n\n\*\*'
                              + re.escape(after) + r':\*\*\n> (.*?)(?=\n\n)', self.readme, re.S)
            self.assertEqual((match[1], match[2]), (cases['readme-'+lang]['input'], cases['readme-'+lang]['output']))
        self.assertEqual(self.readme.count('**After (Universal Humanizer):**'), 1)
        self.assertEqual(self.readme.count('**После (Universal Humanizer):**'), 1)

    def test_audit_has_unique_ids_and_claim_notes(self):
        self.assertEqual(len(self.cases), 47)
        self.assertEqual(len({c['id'] for c in self.cases}), 47)
        for case in self.cases:
            self.assertTrue(case['input'] and case['output'] and case['invariants'])

    def test_generated_example_bodies_are_current(self):
        self.assertEqual((ROOT / 'skills/universal-humanizer/SKILL.md').read_text(), self.skill)
        body = re.sub(r'\A---\n.*?\n---\n', '', self.skill, flags=re.S).strip()
        for path in ['rules/humanizer.md', 'prompts/humanizer.md']:
            self.assertTrue((ROOT / path).read_text().endswith(body + '\n'), path)

    def test_known_factual_regressions_differ_from_review(self):
        cases = {c['id']: c for c in self.cases}
        rejected = {
            'readme-quick': 'We migrated to Apache Kafka last month at 12,000 events per second.',
            'skill-09-en': 'This indexing strategy improves throughput.',
            'skill-08-en': 'The container crashed because of an unhandled null pointer.',
            'skill-17-ru': 'Монолитная архитектура устарела.',
            'skill-11-ru': 'Команда инфраструктуры перевела логи сервиса в формат JSON.',
        }
        for key, candidate in rejected.items():
            # This locks a reviewed pair, not a general semantic scoring algorithm.
            self.assertNotEqual(candidate, cases[key]['output'])

    def test_readme_does_not_restore_absolute_guarantees(self):
        for claim in ['100% Local', '100% local', 'Zero Hallucination Guarantee',
                      'Your text is never transmitted', 'preserved byte-for-byte']:
            self.assertNotIn(claim, self.readme)
        self.assertIn('host agent may transmit', self.readme)
        self.assertIn('not programmatic guarantees', self.readme)


if __name__ == '__main__':
    unittest.main()
