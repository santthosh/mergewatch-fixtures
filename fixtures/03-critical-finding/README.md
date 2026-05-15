# E2E-03: Critical finding → inline comment

A critical finding on a changed line should produce an inline review comment and a single REQUEST_CHANGES formal review.

## Apply

```bash
./scripts/apply-fixture.sh 03-critical-finding
```

## Expected outcomes

- [ ] Inline review comment lands on the `pool.query(...)` line
- [ ] Inline body starts with `**🔴 <title>**` and includes a Suggestion section
- [ ] Inline body contains hidden `<!-- mergewatch-inline -->` marker (verify via `gh api repos/<owner>/mergewatch-fixtures/pulls/<N>/comments`)
- [ ] Summary comment shows `🟠 2/5 — Needs fixes` or `🔴 1/5 — Do not merge`
- [ ] "Requires your attention" table lists the SQL Injection row with 🔴
- [ ] Formal PR review state = **Changes requested** (single review event — NOT multiple COMMENTED reviews)
- [ ] Review body is a single line that points at the summary comment, e.g. *"🔴 Critical issues found — see the full review in the summary comment above."*
- [ ] Check run conclusion = `failure` with title like "N critical issues found"

## Failure modes

- ❌ Formal review state is `COMMENTED` instead of `CHANGES_REQUESTED` (regression of #139 — was the bug observed in mergewatch-fixtures PR #3)
- ❌ Multiple COMMENTED reviews (one per inline comment) instead of one CHANGES_REQUESTED with bundled inlines
- ❌ Review body is empty or matches the old multi-section verdict block — both are wrong; a one-line pointer is the target
