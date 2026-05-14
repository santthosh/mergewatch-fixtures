# E2E-13: Inline-reply engages on MergeWatch thread

Replying to a MergeWatch inline comment should trigger a focused conversational response.

> Reuses the open E2E-03 PR (the SQL-injection one with an inline MergeWatch comment).

## Run

In the GitHub UI, reply to MergeWatch's inline comment with:

```
Can you elaborate on the parameterized query suggestion?
```

## Expected outcomes

- [ ] 👀 reaction appears on YOUR reply within ~10s
- [ ] MergeWatch posts a follow-up reply in the same inline thread within ~30s
- [ ] 👀 reaction removed once the reply lands
- [ ] Reply is reasonably on-topic about parameterized queries
- [ ] Reply does NOT contain the `<!-- mergewatch-inline -->` marker visibly (HTML-comment hidden)

## Resolve fast-path

Post `/resolve` as a reply. MergeWatch should resolve the thread via GraphQL within ~10s without invoking the LLM.
