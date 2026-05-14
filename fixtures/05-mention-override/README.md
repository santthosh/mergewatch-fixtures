# E2E-05: autoReview off + @mergewatch override

Even with `autoReview: false`, `@mergewatch review` must force a full review. The silent gate must honor `mentionTriggered`.

> Reuses the open E2E-04 PR. Do not open a new PR.

## Run

After E2E-04 has produced zero trace on its PR, post a comment on that same PR:

```
@mergewatch review
```

(Or via gh: `gh pr comment <N> --body "@mergewatch review"`)

## Expected outcomes

- [ ] 👀 reaction within ~10s after the comment
- [ ] In-progress check run appears
- [ ] Summary comment posted
- [ ] Formal PR review submitted
- [ ] All trace absent in E2E-04 is now present

## Failure modes

- ❌ No reaction / no review — silent gate isn't honoring `mentionTriggered` (regression of `skip-logic.ts`)
