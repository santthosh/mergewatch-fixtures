# E2E-08: Smart-skip bypass via mention

Same outcome as E2E-07 but proves `@mergewatch review` overrides smart-skip even without `includePatterns`.

> Reuses the open E2E-06 PR. Do not open a new PR.

## Run

After E2E-06's "Review skipped" check run appears, post:

```
@mergewatch review
```

(Or: `gh pr comment <N> --body "@mergewatch review"`)

## Expected outcomes

- [ ] Review runs full pipeline despite docs-only content
- [ ] Summary comment posted
- [ ] (Initial skip check run remains in history — fine)
