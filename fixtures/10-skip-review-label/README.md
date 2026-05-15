# E2E-10: ignoreLabels skip

A PR carrying a label in `rules.ignoreLabels` is skipped. `skip-review` is the default `ignoreLabels` entry.

> **Important**: MergeWatch only re-evaluates skip rules on `pull_request` events with action `opened` / `synchronize` / `ready_for_review` / `reopened` (see `REVIEW_TRIGGERING_ACTIONS`). The `labeled` action is **not** in that list — adding a label to an already-reviewed PR will NOT cancel the in-flight review. To test this fixture correctly, add the label **before** the first commit lands, or follow the label add with a synchronize event.

## Apply

```bash
./scripts/apply-fixture.sh 10-skip-review-label
```

Then choose one path:

**Path A — label, then synchronize:**

```bash
gh pr edit <N> --add-label skip-review
git commit --allow-empty -m 'trigger synchronize'
git push
```

**Path B — open as draft, label, mark ready:**

```bash
# (Note: the runner currently opens 10 as non-draft. To use Path B, edit
#  fixtures/10-skip-review-label/meta.env and set DRAFT=true before running.)
gh pr edit <N> --add-label skip-review
gh pr ready <N>
```

If the label `skip-review` doesn't exist on the fixtures repo yet, create it first:

```bash
gh label create skip-review --description "Skip MergeWatch review" --color ededed
```

## Expected outcomes

- [ ] Visible "Review skipped" check run with summary like `PR has label "skip-review" which is in ignoreLabels`
- [ ] If a prior MergeWatch review was already submitted, it is **dismissed** by the new skip evaluation

## Known gap

- ❌ Adding the `skip-review` label to a PR that's already mid-review (or already reviewed) does **not** cancel/supersede the existing review. The webhook only fires for the actions listed above. Tracked as a deliberate limitation — handling `labeled` / `unlabeled` actions specifically would be a non-trivial code change.
