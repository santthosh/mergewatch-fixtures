# E2E-12: Re-run check via GitHub UI

Clicking the "Re-run" button on the MergeWatch check should trigger a fresh review on the same commit.

> Manual GitHub-UI action. No fixture overlay.

## Run

Open any completed fixture PR. In the Checks tab, click the `⋯` menu next to "MergeWatch Review" → **Re-run**.

## Expected outcomes

- [ ] Within ~30s a new "in progress" check run appears
- [ ] Summary comment is updated in place
- [ ] Behavior identical to a synchronize event
