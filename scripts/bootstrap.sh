#!/usr/bin/env bash
# Bootstrap or restore the mergewatch-fixtures baseline.
#
# - On a fresh clone with no commits: writes seed files, makes the initial
#   commit, tags it `e2e-baseline`, and pushes main + tags to origin.
# - On an existing clone where `e2e-baseline` already exists: resets the
#   working tree back to that tag and cleans any untracked fixture cruft.
set -euo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null || dirname "$(cd "$(dirname "$0")" && pwd)")"

if git rev-parse e2e-baseline >/dev/null 2>&1; then
  echo "e2e-baseline tag exists — resetting working tree."
  git checkout main 2>/dev/null || git checkout -B main
  git reset --hard e2e-baseline
  git clean -fd -- ':!fixtures' ':!scripts'
  echo "Reset complete. Baseline = $(git rev-parse --short e2e-baseline)."
  exit 0
fi

echo "No e2e-baseline tag found — seeding baseline."

if git rev-parse HEAD >/dev/null 2>&1; then
  echo "Repo already has commits but no e2e-baseline tag." >&2
  echo "Tag the seed commit manually: git tag e2e-baseline && git push origin e2e-baseline" >&2
  exit 1
fi

# Files are expected to already be present in the working tree (this script is
# committed alongside them). If a hand-curated baseline drift happens, restore
# from git history rather than re-writing here.
required=(src/app.ts src/utils.ts README.md .gitignore)
for f in "${required[@]}"; do
  if [ ! -f "$f" ]; then
    echo "Missing baseline file: $f" >&2
    exit 1
  fi
done

git add src/app.ts src/utils.ts README.md .gitignore scripts/ fixtures/ 2>/dev/null || true
git commit -m "Seed fixtures repo"
git tag e2e-baseline
git push -u origin main
git push origin e2e-baseline

echo "Baseline created and pushed. Tag = $(git rev-parse --short e2e-baseline)."
