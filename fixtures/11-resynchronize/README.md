# E2E-11: Re-review on synchronize

Pushing a new commit to an open PR should:
- Dismiss any prior formal PR reviews
- Edit the existing summary comment in place (not post a new one)
- Track the delta between commits (delta caption)

> Reuses the open E2E-01 PR.

## Run

After E2E-01 completes its first review:

```bash
git checkout fixture/01-clean-pr
echo "// added in commit 2" >> src/utils.ts
git commit -am "Second commit"
git push
```

## Expected outcomes

- [ ] Original formal PR review now shows as **Dismissed** (struck-through in GitHub UI)
- [ ] Single summary comment (not two) — edited in place via `BOT_COMMENT_MARKER` lookup
- [ ] Comment body's commit SHA reference at the bottom updates to the new SHA
- [ ] If findings changed, a delta caption appears ("Resolved X, introduced Y")
- [ ] Commit-hash link in comment footer points at the new commit
