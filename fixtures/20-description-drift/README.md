# E2E-20: PR description vs code drift catch

When a PR description claims behavior the diff doesn't reflect, the reviewer should flag the drift. This fixture deliberately ships a PR body that claims `localStorage.setItem` while the diff uses an in-memory Map — the same pattern as the real catch on `mergewatch.ai#18` ("description still said localStorage after I'd dropped it in commit c1e3a06").

This is a **spot-check**, not a hard pass/fail — the LLM doesn't always catch description drift, but it should at least notice on obvious cases.

## Apply

```bash
./scripts/apply-fixture.sh 20-description-drift
```

The runner sets the PR body to:
> *This PR adds preference persistence using `localStorage.setItem` so user choices survive page reloads. The key format is `pref:<name>`.*

…while the overlay's `src/persistence.ts` uses `memCache.set(...)`, not `localStorage.setItem(...)`.

## Expected outcomes (spot-check)

- [ ] At least one info or warning finding mentions that the PR description references `localStorage` but the diff has dropped it
- [ ] The mismatch surfaces in the summary text or the "Requires your attention" table
- [ ] **Bonus**: the verdict reason or summary notes the description should be updated

## Note

This is the only fixture where a miss isn't necessarily a bug. PR-description drift detection is best-effort. If MergeWatch never catches it, that's a quality bar to raise; if it catches some but not all, log the misses for prompt tuning.

## Two-commit variant (optional)

The runbook describes a two-commit history (first commit uses localStorage, second drops it). To exercise commit-history awareness:

```bash
# After applying 20-description-drift and before opening the PR, replace the overlay
# with a localStorage-first version and commit, then amend back to memCache and commit again.
```

The single-commit version above is sufficient for the core spot-check.
