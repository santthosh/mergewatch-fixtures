# E2E-15: Mermaid diagram renders

Complex PRs should produce a Mermaid `flowchart TD` diagram that renders correctly in the GitHub UI (no parse errors). Multiple sanitizer fixes shipped in #128–#130.

## Apply

```bash
./scripts/apply-fixture.sh 15-mermaid-stress
```

The overlay adds five files chosen for historically-problematic characters in their paths/contents:

```
src/auth/oauth-callback.ts        (tab/newline in JSDoc)
src/utils/string-helpers.ts       (HTML escapes inside docstring)
src/db/migrations/0042-add.sql    (slashes + numbers in path)
src/api/v1/users.ts               (multi-segment path)
src/components/<Title>.tsx        (angle brackets in filename)
```

## Expected outcomes

- [ ] Diagram block in the summary comment renders inline in the GitHub PR view (no `mermaid parse error` shown)
- [ ] Diagram includes labeled boxes for each touched file
- [ ] No raw `&lt;` / `&gt;` HTML entities visible (Mermaid decodes them)
- [ ] No literal `<br/>` tags visible in node labels (render as line breaks)
- [ ] Tabs / lone CR characters in upstream content don't break the diagram

## Failure modes

- ❌ "Unable to render rich display" or red error block
- ❌ Diagram truncates mid-node label
- ❌ Quoted labels show literal escape sequences
