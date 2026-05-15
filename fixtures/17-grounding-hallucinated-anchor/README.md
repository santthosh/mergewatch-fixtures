# E2E-17: Finding grounding drops hallucinated anchors

A finding whose cited anchor line doesn't contain the code it describes should be dropped or snapped to the real code line. The grounding step in `runReviewPipeline` re-fetches the file at the PR's headSha and verifies an identifier from the finding's description appears within ±5 lines of the anchor; otherwise it snaps or drops.

Verifies the regression flagged in user feedback: *"the bot anchored a critical 'race condition' at lines 89–91 (which are comment lines), when the actual `await createChatSession()` was on line 92."*

## Apply

```bash
./scripts/apply-fixture.sh 17-grounding-hallucinated-anchor
```

## Expected outcomes

- [ ] Any race-condition / fire-and-forget critical finding's `line` field points at **line 10 or 11** (the `await createChatSession` / `await addChatMessage` lines) — NOT lines 1–8
- [ ] If the orchestrator emitted such a finding in the comment region (1–8), grounding snapped it OR dropped it
- [ ] No finding's anchor line is on a `//`-only line in the rendered "Requires your attention" table
- [ ] Dashboard review record (or DynamoDB `findings`) shows snapped line numbers

## Failure modes

- ❌ Critical finding rendered at lines 1–8 (anchor on a comment line)
- ❌ Critical finding describing functions that don't appear in `src/race-trap.ts` at all (full hallucination — grounding should have dropped it)

## Note

This fixture is stochastic — the LLM may not always anchor on a comment line. To force the failure mode pre-fix, inject `{ "file": "src/race-trap.ts", "line": 3, "severity": "critical", "title": "Race condition", "description": "createChatSession() and addChatMessage() are not awaited together." }` into the orchestrator response in a local self-hosted run.
