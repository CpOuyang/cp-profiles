#!/usr/bin/env bash
set -euo pipefail

# Ensures that ~/.bash_profile.local exists with a standard header.
# If the file already exists, prepends the header when missing.

TARGET="${BASH_PROFILE_LOCAL_PATH:-${HOME}/.bash_profile.local}"
HEADER_ANCHOR="# cp-profiles local Bash overrides"

create_header() {
  cat <<'EOT'
# --------------------------------------------------------------------
# cp-profiles local Bash overrides
# Add machine-specific exports, secrets, or PATH tweaks here.
# This file is not under version control.
# --------------------------------------------------------------------

# Example overrides:
# export GITHUB_ACCESS_TOKEN="example-token"
# export PATH="$HOME/.cargo/bin:$PATH"
EOT
}

if [[ -f "$TARGET" ]]; then
  if ! grep -Fq "$HEADER_ANCHOR" "$TARGET"; then
    tmp_file="$(mktemp)"
    create_header >"$tmp_file"
    cat "$TARGET" >>"$tmp_file"
    mv "$tmp_file" "$TARGET"
    echo "Updated header for $TARGET"
  else
    echo "Local profile already initialised at $TARGET"
  fi
else
  create_header >"$TARGET"
  chmod 600 "$TARGET"
  echo "Created $TARGET"
fi
