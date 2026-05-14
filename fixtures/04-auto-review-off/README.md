# E2E-04: autoReview off → silent

With `rules.autoReview: false`, MergeWatch leaves no trace on the PR (no reaction, no check run, no review, no comment). Ships in #136.

> Keep this PR open after running — E2E-05 reuses it.

## Apply

```bash
./scripts/apply-fixture.sh 04-auto-review-off
```

## Expected outcomes

- [ ] No 👀 reaction
- [ ] No "MergeWatch Review" check run (Checks tab)
- [ ] No summary comment
- [ ] No formal PR review
- [ ] No inline comments
- [ ] Logs show single line: `autoReview off — silently skipping <owner>/<repo>#<N>`
- [ ] DynamoDB `mergewatch-reviews` (or Postgres `reviews`) has NO row for this commit SHA

## Failure modes

- ❌ "Auto-review is disabled for this repository" check run — pre-#136 behavior
- ❌ 👀 reaction lands then disappears — shouldn't have been added at all
