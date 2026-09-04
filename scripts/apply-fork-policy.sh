#!/usr/bin/env bash
set -euo pipefail

# NOTE: This is a dev-only script, intended for maintainers of this fork.
#
# Applies this fork's one divergence from upstream: model-invoked is the
# default. A skill is user-invoked only when an agent reaching for it
# autonomously would be a problem in itself, not merely unhelpful. Today that
# is setup-matt-pocock-skills alone, because it rewrites the repo's issue
# tracker, triage labels and domain doc layout. See .agents/invocation.md.
#
# Run it after every merge from upstream. Upstream ships new skills with
# `disable-model-invocation: true` set, and those arrive through a clean merge
# with no conflict to warn you, so nothing else catches them.
#
# The script enforces the rule in both directions, and is idempotent:
#   - a skill NOT in USER_INVOKED loses `disable-model-invocation` from its
#     SKILL.md and `policy.allow_implicit_invocation` from agents/openai.yaml
#   - a skill IN USER_INVOKED gains both if they are missing
#
# Usage:
#   scripts/apply-fork-policy.sh          rewrite files to match the policy
#   scripts/apply-fork-policy.sh --check  report drift, change nothing, exit 1

REPO="$(cd "$(dirname "$0")/.." && pwd)"

# The allowlist. Every other skill in the repo is model-invoked.
USER_INVOKED=(
  "setup-matt-pocock-skills"
)

CHECK_ONLY=0
if [[ "${1:-}" == "--check" ]]; then
  CHECK_ONLY=1
elif [[ $# -gt 0 ]]; then
  echo "usage: $0 [--check]" >&2
  exit 2
fi

drift=0

is_user_invoked() {
  local name="$1"
  for exempt in "${USER_INVOKED[@]}"; do
    [[ "$name" == "$exempt" ]] && return 0
  done
  return 1
}

# Reports one difference between the policy and what is on disk. In --check
# mode that is all it does; otherwise the caller goes on to fix it.
report() {
  drift=$((drift + 1))
  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo "  drift: $1"
  else
    echo "  fixed: $1"
  fi
}

# Deletes a line from a file in place, tolerating CRLF.
strip_line() {
  local file="$1" pattern="$2"
  sed -i "/$pattern/d" "$file"
}

# Inserts a line just before the closing --- of a SKILL.md's front matter.
insert_into_frontmatter() {
  local file="$1" line="$2"
  awk -v ins="$line" '
    BEGIN { fences = 0 }
    {
      stripped = $0; sub(/\r$/, "", stripped)
      if (stripped == "---") {
        fences++
        if (fences == 2) print ins
      }
      print
    }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

for skill_md in "$REPO"/skills/*/*/SKILL.md; do
  dir="$(dirname "$skill_md")"
  name="$(basename "$dir")"
  rel="${dir#"$REPO"/}"
  yaml="$dir/agents/openai.yaml"

  has_flag=0
  grep -q '^disable-model-invocation:' "$skill_md" && has_flag=1

  has_policy=0
  [[ -f "$yaml" ]] && grep -q 'allow_implicit_invocation:' "$yaml" && has_policy=1

  if is_user_invoked "$name"; then
    if [[ $has_flag -eq 0 ]]; then
      report "$rel/SKILL.md is missing disable-model-invocation"
      [[ $CHECK_ONLY -eq 0 ]] && insert_into_frontmatter "$skill_md" "disable-model-invocation: true"
    fi
    if [[ -f "$yaml" && $has_policy -eq 0 ]]; then
      report "$rel/agents/openai.yaml is missing policy.allow_implicit_invocation"
      [[ $CHECK_ONLY -eq 0 ]] && printf 'policy:\n  allow_implicit_invocation: false\n' >> "$yaml"
    fi
    continue
  fi

  if [[ $has_flag -eq 1 ]]; then
    report "$rel/SKILL.md carries disable-model-invocation"
    [[ $CHECK_ONLY -eq 0 ]] && strip_line "$skill_md" '^disable-model-invocation:'
  fi

  if [[ $has_policy -eq 1 ]]; then
    # Only the allow_implicit_invocation key is ours to remove. If upstream
    # ever puts anything else under `policy:`, say so and leave it alone
    # rather than dropping a key we do not understand.
    others="$(sed -n '/^policy:/,$p' "$yaml" | tail -n +2 | grep -c '^[[:space:]]\+[a-z_]\+:' || true)"
    if [[ "$others" -gt 1 ]]; then
      echo "  SKIPPED: $rel/agents/openai.yaml has other keys under policy:, resolve by hand" >&2
      drift=$((drift + 1))
    else
      report "$rel/agents/openai.yaml carries policy.allow_implicit_invocation"
      if [[ $CHECK_ONLY -eq 0 ]]; then
        strip_line "$yaml" '^policy:'
        strip_line "$yaml" '^[[:space:]]*allow_implicit_invocation:'
      fi
    fi
  fi
done

if [[ $drift -eq 0 ]]; then
  echo "Fork policy holds: ${#USER_INVOKED[@]} user-invoked skill(s), everything else model-invoked."
  exit 0
fi

if [[ $CHECK_ONLY -eq 1 ]]; then
  echo
  echo "$drift skill file(s) drifted from the fork policy. Run scripts/apply-fork-policy.sh to fix."
  exit 1
fi

echo
echo "Applied the fork policy to $drift skill file(s). Review the diff before committing."
