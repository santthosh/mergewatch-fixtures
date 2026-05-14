# E2E-16: Agent-authored PR detection

A PR from a `claude/*`-prefixed branch should be classified as agent-authored and trigger agent-mode prompt suffixes / persist `source: 'agent', agentKind: 'claude'`.

## Apply

```bash
./scripts/apply-fixture.sh 16-agent-authored
```

The runner uses branch `claude/fix-greet-bug` (not the `fixture/` prefix used by other cards).

## Expected outcomes

- [ ] Logs: `Classified <owner>/<repo>#<N> as agent (claude) via branch`
- [ ] Summary comment renders normally (no visible difference — verification is internal)
- [ ] DynamoDB review record (or Postgres `reviews.source`) has `source: 'agent', agentKind: 'claude'`
- [ ] If `agentReview.strictChecks: true` (default), prompt-mode suffix applied → review tone may be terser on logic findings

## Inspect stored record (SaaS)

```bash
aws dynamodb get-item --table-name mergewatch-reviews \
  --key '{"repoFullName":{"S":"<owner>/mergewatch-fixtures"},"prNumberCommitSha":{"S":"<N>#<shortSha>"}}' \
  --profile mergewatch
```
