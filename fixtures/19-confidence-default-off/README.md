# E2E-19: Confidence scores hidden by default

A fresh MergeWatch install should NOT render `XX%` confidence badges next to findings. The flag still exists (`InstallationSettings.summary.confidenceScore`) and users can opt back in via the dashboard, but the default is off because LLM-self-reported confidence has been observed to be miscalibrated against actual hit rate.

## Apply

```bash
./scripts/apply-fixture.sh 19-confidence-default-off
```

Don't touch any dashboard settings before running.

## Expected outcomes

- [ ] Summary comment includes a "Requires your attention" or "Info" section with at least one finding
- [ ] **No finding row contains a `XX%` badge** — neither in the action-items table nor in the Info collapsible
- [ ] If you turn the setting back on (Settings → Summary → "Show confidence scores"), the next review's findings DO show the badge

## Failure modes

- ❌ `85%`, `90%`, etc. badges appear on a default install (regression of the default flip)
- ❌ The setting toggle in the dashboard doesn't have any effect
