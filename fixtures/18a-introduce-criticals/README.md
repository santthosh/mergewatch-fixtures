# E2E-18a: Introduce criticals (step 1 of 2)

The setup half of E2E-18 (Delta-aware verdict on security improvement). Adds `src/admin-api.ts` with two real critical findings: an unauthenticated admin endpoint and a SQL injection. **Do not merge** — the second step pushes a fix to the same branch and verifies the verdict goes green after delta reconciliation.

## Apply

```bash
./scripts/apply-fixture.sh 18a-introduce-criticals
```

Branch: `fixture/18-delta-aware-verdict` (intentionally shared with 18b).

## Expected outcomes (first review)

- [ ] ≥1 critical findings on `src/admin-api.ts` (missing auth, SQL injection)
- [ ] Verdict lands at `🟠 2/5` or `🔴 1/5` (orange / red)
- [ ] Formal PR review state = **Changes requested**

## Next step

After the first review completes, push the fix:

```bash
./scripts/apply-fixture.sh 18b-fix-criticals
```

That pushes overlay-2 onto the same branch and triggers the delta-aware re-review.
