# E2E-10: ignoreLabels skip

A PR carrying a label in `rules.ignoreLabels` is skipped. `skip-review` is the default `ignoreLabels` entry.

## Apply

```bash
./scripts/apply-fixture.sh 10-skip-review-label
```

Then add the label and trigger a synchronize event:

```bash
gh pr edit <N> --add-label skip-review
# trigger synchronize: push an empty commit or toggle the label
git commit --allow-empty -m "trigger" && git push
```

If the label `skip-review` doesn't exist on the fixtures repo yet, create it first:

```bash
gh label create skip-review --description "Skip MergeWatch review" --color ededed
```

## Expected outcomes

- [ ] Visible "Review skipped" check run, summary like `PR has label "skip-review" which is in ignoreLabels`
