# mergewatch-fixtures

Scratch repo for [MergeWatch](https://github.com/apps/mergewatch) end-to-end tests.

The authoritative test procedure lives upstream: [`mergewatch.ai/e2e/RUNBOOK.md`](https://github.com/santthosh/mergewatch.ai/blob/main/e2e/RUNBOOK.md). This repo holds the fixture overlays and the runner that materializes each fixture as a real GitHub PR.

## Layout

```
src/                          # baseline source tree fixtures mutate
fixtures/<NN-name>/           # one directory per E2E-NN card from the runbook
  overlay/                    # files copied on top of the baseline working tree
  meta.env                    # BRANCH / TITLE / DRAFT / etc. for the runner
  README.md                   # fixture summary + expected-outcomes checklist
scripts/
  bootstrap.sh                # seed + tag e2e-baseline (one-time); also resets between runs
  apply-fixture.sh            # reset → branch → overlay → push → open PR
```

## Workflow

```bash
# one-time (fresh clone only)
./scripts/bootstrap.sh

# run a fixture
./scripts/apply-fixture.sh 01-clean-pr

# verify against fixtures/01-clean-pr/README.md, then tear down
gh pr close <N> --delete-branch
```

`apply-fixture.sh` always resets to `e2e-baseline` before applying an overlay, so fixtures stay reproducible regardless of prior runs.

## Fixture index

| ID | Name | Behavior | Manual? |
|---|---|---|---|
| E2E-01 | `01-clean-pr` | Clean PR → 5/5 + APPROVE + empty review body | |
| E2E-02 | `02-info-only` | Info-only findings → 5/5, "All clear" + Info collapsible | |
| E2E-03 | `03-critical-finding` | Critical finding → inline comment + REQUEST_CHANGES | |
| E2E-04 | `04-auto-review-off` | `autoReview: false` → zero PR trace | |
| E2E-05 | `05-mention-override` | `autoReview: false` + `@mergewatch review` → review runs | reuses 04 |
| E2E-06 | `06-docs-only` | Docs-only → visible "Review skipped" | |
| E2E-07 | `07-include-patterns` | Docs-only + `includePatterns` → review runs | |
| E2E-08 | `08-mention-overrides-skip` | Docs-only + `@mergewatch review` → review runs | reuses 06 |
| E2E-09 | `09-draft-pr` | Draft PR → "Review skipped — Draft PR" | |
| E2E-10 | `10-skip-review-label` | `skip-review` label → "Review skipped — label" | post-open label |
| E2E-11 | `11-resynchronize` | Push new commit → old review dismissed + comment edited in place | reuses 01 |
| E2E-12 | `12-rerun-check` | Click "Re-run" on the check → new review fires | UI only |
| E2E-13 | `13-inline-reply-engages` | Human replies in MergeWatch inline thread → MergeWatch responds | reuses 03 |
| E2E-14 | `14-third-party-thread` | Human replies in non-MergeWatch thread → no engagement | post-open UI |
| E2E-15 | `15-mermaid-stress` | Complex diff → renderable Mermaid diagram | |
| E2E-16 | `16-agent-authored` | PR from `claude/*` branch → flagged as agent-authored | |
| E2E-17 | `17-grounding-hallucinated-anchor` | Comment-line anchor → grounding snaps or drops the finding | stochastic |
| E2E-18 | `18a-introduce-criticals` → `18b-fix-criticals` | Two-step: criticals introduced → fix pushed → delta-aware green verdict | sequenced |
| E2E-19 | `19-confidence-default-off` | No `XX%` confidence badges on a default install | |
| E2E-20 | `20-description-drift` | PR description claims `localStorage` but diff uses memCache → reviewer flags drift | spot-check |

Each `fixtures/<NN-name>/README.md` has the verification checklist for that card.

## Two-step fixtures

E2E-18 ships as two fixture directories sharing one branch (`fixture/18-delta-aware-verdict`):

```bash
./scripts/apply-fixture.sh 18a-introduce-criticals   # opens the PR with security holes
# wait for first review (orange/red verdict)
./scripts/apply-fixture.sh 18b-fix-criticals         # pushes fix to same branch, no new PR
# wait for second review (should be green per delta-aware reconciliation)
```

`18b` uses the runner's `PUSH_TO_EXISTING_BRANCH` mode — it checks out the existing branch from origin, overlays the fix, and pushes a synchronize commit without opening a new PR.

## Smoke test (~5 min)

```bash
./scripts/apply-fixture.sh 01-clean-pr
./scripts/apply-fixture.sh 04-auto-review-off
./scripts/apply-fixture.sh 06-docs-only
```

If all three behave per their fixture READMEs, the deploy is at least minimally healthy.
