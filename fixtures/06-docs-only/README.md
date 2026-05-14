# E2E-06: Smart skip — docs only

A PR touching only docs/lock files should skip review and post a **visible** "Review skipped" check run.

## Apply

```bash
./scripts/apply-fixture.sh 06-docs-only
```

## Expected outcomes

- [ ] 👀 reaction briefly
- [ ] **Visible** check run "Review skipped" with summary like `Only docs changed`
- [ ] No summary comment
- [ ] No formal PR review
- [ ] (Auto-review IS on — this is the smart-skip path, NOT the silent path)
