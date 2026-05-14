# E2E-03: Critical finding → inline comment

A critical finding on a changed line should produce an inline review comment + REQUEST_CHANGES formal review.

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
- [ ] Formal PR review state = **Changes requested**
- [ ] Review has a non-empty body (REQUEST_CHANGES requires it)
