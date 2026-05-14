# E2E-09: Draft PR skip

Draft PRs are skipped by default (`skipDrafts: true`) with a visible check run.

## Apply

```bash
./scripts/apply-fixture.sh 09-draft-pr
```

The runner opens this PR with `--draft`.

## Expected outcomes

- [ ] Visible "Review skipped" check run, summary mentions "Draft PR"
- [ ] No summary comment
- [ ] No formal PR review

## Bonus

Convert to ready-for-review:

```bash
gh pr ready <N>
```

MergeWatch should now run a full review (synchronize-equivalent event).
