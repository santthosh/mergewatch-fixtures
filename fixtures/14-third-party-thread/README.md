# E2E-14: Inline-reply skips third-party bot thread

MergeWatch must NOT engage when a human replies to a thread NOT rooted in a MergeWatch comment (e.g., CopilotAI's, or a human's inline finding). Fix from #133.

## Apply

```bash
./scripts/apply-fixture.sh 14-third-party-thread
```

Wait for MergeWatch's review to land. Then manually:

1. Leave a NEW top-level inline comment on a line of the diff that MergeWatch did **not** comment on (use the "+ Add comment" gutter button in the GitHub UI).
2. Reply to that inline comment yourself with `@mergewatch what do you think?` or simply `looks fine`.

## Expected outcomes

- [ ] MergeWatch does NOT post a reply in the human-rooted thread
- [ ] MergeWatch DOES still respond if you reply in its own thread on the same PR (sanity check)
- [ ] Logs show `thread root is not a MergeWatch comment` skip reason (CloudWatch / stdout)

## Failure modes

- ❌ MergeWatch replies in a thread it didn't start — the interference the user explicitly called out
