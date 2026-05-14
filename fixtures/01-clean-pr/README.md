# E2E-01: Clean PR → full review

A PR with no issues should produce 5/5 "Safe to merge", an APPROVE on the formal PR review with **empty body** (verdict block removed in #132), and a summary comment with "All clear!".

## Apply

```bash
./scripts/apply-fixture.sh 01-clean-pr
```

## Expected outcomes

- [ ] 👀 reaction within ~10s
- [ ] In-progress check run "Review in progress" appears
- [ ] Summary comment with:
  - [ ] MergeWatch wordmark (~48px tall) at top
  - [ ] `🟢 5/5 — Safe to merge` verdict line
  - [ ] `🎉 All clear! No issues found` action-items section
- [ ] Formal PR review state = **Approved**
- [ ] Approved review has **NO body text** (regression of #132 if it does)
- [ ] Completed check run "MergeWatch Review" → success
- [ ] +1 👍 reaction (success signal); 👀 reaction removed
