# Published-example audit (UH-01)

`published-examples.json` records all 44 root skill before/after pairs and all
three README transformations. Each record includes the full source, reviewed
output, and a claim/invariant comparison. The quick-start input repeats the
README table input. `assets/voice-sample-template.md` contains placeholders,
not a transformation pair; the command derivative also has no pair. Nested
skill, rule, and prompt examples are generated from the reviewed root source.

No hidden context was added. The audit removes invented technology, timings,
metrics, causes, actors, features, and citations. Some examples intentionally
remain unchanged because the source gives insufficient detail. Promotional
rhetoric can be trimmed without adding substitute facts. Pattern 23 EN explicitly
omits conjecture, preserving the missing-records limitation. Pattern 23 RU retains
the tentative prediction. Pattern 25 retains history and intent because deleting
them would lose supplied information.

## Review rubric

For every pair, compare input and output claims in both directions:

1. Keep source entities, numbers, units, dates, actions, and technical scope.
2. Preserve negation, uncertainty, attribution, causality, and intent vs outcome.
3. Reject new technologies, actors, reasons, properties, citations, or measurements.
4. Keep unsupported attributed claims attributed and request a source separately.
5. Retain good prose when a stylistic edit would change meaning.

Negative examples: adding Kafka, a date, or 12,000 events/s to the README input
fails rule 3; changing “might improve” to “improves” fails rule 2. Changing
“не подтверждено” to “опровергнуто” also fails rule 2. Dropping “Эксперты
утверждают” changes attribution; a decision to change logs is not a completed
JSON migration by a named team.

Run `python3 -m unittest discover -s tests -v` and
`python3 scripts/validate-package.py` offline. The tests lock the exact reviewed
pairs, coverage, generated bodies, and known misleading claims. They are
regression checks of published documentation, not automated factual entailment,
a protected-file verifier, or a model-behavior evaluation. An alternative valid
rewrite requires renewed semantic review and an explained fixture update.
No provider calls, live model evaluation, or pass-rate claims are included.
A separate UH-02 corpus and live evaluation remain future work.
