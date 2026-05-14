#!/usr/bin/env bash
# Apply a fixture from fixtures/<NN-name>/ and open a PR.
#
# Flow:
#   1. validate fixture dir + meta.env
#   2. reset working tree to e2e-baseline (refuses if dirty)
#   3. create the fixture branch (force-recreates if it already exists locally)
#   4. copy overlay/ files on top of the baseline working tree
#   5. commit, push, open PR via gh
#
# Fixtures with SKIP_APPLY=true in their meta.env (reusing another PR) and
# MANUAL_ONLY=true (no overlay, no PR) just print instructions and exit.
set -euo pipefail

usage() {
  cat >&2 <<EOF
usage: $0 <fixture-name>

Examples:
  $0 01-clean-pr
  $0 16-agent-authored

Available fixtures:
$(ls -1 "$(dirname "$0")/../fixtures" 2>/dev/null | sed 's/^/  /')
EOF
  exit 1
}

[ $# -eq 1 ] || usage
NAME="$1"

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

FIXTURE_DIR="fixtures/$NAME"
META="$FIXTURE_DIR/meta.env"
OVERLAY="$FIXTURE_DIR/overlay"

if [ ! -d "$FIXTURE_DIR" ]; then
  echo "Fixture not found: $FIXTURE_DIR" >&2
  usage
fi
if [ ! -f "$META" ]; then
  echo "Missing $META" >&2
  exit 1
fi

# --- parse meta.env ---------------------------------------------------------
# Format: KEY=VALUE per line. Values may contain spaces (no quoting required).
# Comments (#) and blank lines are ignored.
BRANCH=""; TITLE=""; BODY=""; DRAFT="false"
SKIP_APPLY="false"; MANUAL_ONLY="false"; REUSES=""; POST_OPEN_HINT=""
while IFS='=' read -r key value; do
  # strip trailing \r in case of CRLF
  value="${value%$'\r'}"
  case "$key" in
    BRANCH) BRANCH="$value" ;;
    TITLE) TITLE="$value" ;;
    BODY) BODY="$value" ;;
    DRAFT) DRAFT="$value" ;;
    SKIP_APPLY) SKIP_APPLY="$value" ;;
    MANUAL_ONLY) MANUAL_ONLY="$value" ;;
    REUSES) REUSES="$value" ;;
    POST_OPEN_HINT) POST_OPEN_HINT="$value" ;;
    "" | \#*) ;;
  esac
done < <(grep -v '^[[:space:]]*#' "$META" | grep '=')

# --- handle reuse / manual-only fixtures -----------------------------------
if [ "$MANUAL_ONLY" = "true" ]; then
  cat <<EOF
$NAME is a manual fixture (no overlay, no new PR).

$BODY

See $FIXTURE_DIR/README.md for the procedure.
EOF
  exit 0
fi

if [ "$SKIP_APPLY" = "true" ]; then
  cat <<EOF
$NAME reuses an existing PR (${REUSES:-see README}).

$BODY

See $FIXTURE_DIR/README.md for the next step (typically a PR comment or push).
EOF
  exit 0
fi

# --- validate prerequisites -------------------------------------------------
if ! git rev-parse e2e-baseline >/dev/null 2>&1; then
  echo "e2e-baseline tag not found. Run scripts/bootstrap.sh first." >&2
  exit 1
fi
if [ -z "$BRANCH" ] || [ -z "$TITLE" ]; then
  echo "meta.env must define BRANCH and TITLE" >&2
  exit 1
fi
if [ ! -d "$OVERLAY" ]; then
  echo "Missing overlay directory: $OVERLAY" >&2
  exit 1
fi
if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found on PATH. Install: https://cli.github.com/" >&2
  exit 1
fi

# Refuse to clobber uncommitted local changes.
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree has uncommitted changes. Commit, stash, or run scripts/bootstrap.sh." >&2
  exit 1
fi

# --- reset to baseline ------------------------------------------------------
echo "→ Resetting to e2e-baseline."
# Drop to a detached HEAD first so deleting/recreating the fixture branch is safe.
git checkout --quiet e2e-baseline
git clean -fd >/dev/null

# --- create the branch ------------------------------------------------------
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "→ Local branch $BRANCH exists — deleting before recreate."
  git branch -D "$BRANCH" >/dev/null
fi
echo "→ Creating $BRANCH from e2e-baseline."
git checkout --quiet -b "$BRANCH"

# --- overlay files ----------------------------------------------------------
echo "→ Applying overlay from $OVERLAY."
# Use find -print0 to survive weird filenames (angle brackets, spaces).
find "$OVERLAY" -type f -print0 | while IFS= read -r -d '' src; do
  rel="${src#$OVERLAY/}"
  dest="$REPO_ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "    + $rel"
done

# --- commit + push ----------------------------------------------------------
git add -A
if git diff --cached --quiet; then
  echo "Overlay produced no changes vs. baseline — nothing to commit." >&2
  exit 1
fi
git commit --quiet -m "$TITLE"
echo "→ Pushing $BRANCH."
git push --quiet -u origin "$BRANCH" --force-with-lease

# --- open PR ----------------------------------------------------------------
PR_ARGS=(pr create --title "$TITLE" --body "$BODY" --base main --head "$BRANCH")
if [ "$DRAFT" = "true" ]; then
  PR_ARGS+=(--draft)
fi
echo "→ Opening PR."
PR_URL="$(gh "${PR_ARGS[@]}")"

echo ""
echo "✓ Fixture $NAME applied."
echo "  Branch: $BRANCH"
echo "  PR:     $PR_URL"
if [ -n "$POST_OPEN_HINT" ]; then
  echo ""
  echo "  Next step hint: $POST_OPEN_HINT"
fi
echo ""
echo "Wait ~30-90s for MergeWatch, then verify against:"
echo "  $FIXTURE_DIR/README.md"
