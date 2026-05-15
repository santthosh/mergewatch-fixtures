# E2E-18b: Fix criticals (step 2 of 2)

Pushes the security fix on top of E2E-18a's branch (`fixture/18-delta-aware-verdict`). MergeWatch should re-review and produce a **green verdict** (≥4/5) reflecting that the criticals were resolved.

> Prerequisite: E2E-18a's PR is open and has completed its first review (verdict orange/red with criticals).

## Apply

```bash
./scripts/apply-fixture.sh 18b-fix-criticals
```

This fixture uses `PUSH_TO_EXISTING_BRANCH` semantics:
- No new branch, no new PR
- Checks out `fixture/18-delta-aware-verdict` from origin
- Applies the fixed `src/admin-api.ts` overlay
- Commits + pushes (synchronize triggers the re-review)

## Expected outcomes (second review)

- [ ] "📎 Previously reported findings" section shows ≥1 criticals from step 1 marked as **✅ Resolved**
- [ ] No new critical findings introduced
- [ ] Verdict line shows `🟢 4/5 — Generally safe` or `🟢 5/5 — Safe to merge` — NOT `🟠 2/5 — Needs fixes`
- [ ] Verdict reason mentions resolved criticals (e.g. *"Resolved N critical issues from prior review, no new criticals introduced"*)
- [ ] Formal PR review state = **Approved** (empty body)
- [ ] Delta caption summarises the resolution (e.g. *"Replaced unauthenticated admin endpoints with `requireAdmin` guards and parameterized the SQL query"*)

## Failure modes

- ❌ Score still orange/red despite zero new criticals (delta-aware reconciliation regressed)
- ❌ Resolved criticals counted as still-open in the verdict reason
