#!/bin/bash

# Wrapper for the formatter that passes action args and processes the output.
# Required args:
# - File include glob pattern.
# - Whether to fail on file changes.
# - Files to be formatted

if [[ $# -ne 3 ]]; then
  echo 'Exactly three parameters (input file pattern, fail on changes, files) required.'
  exit 1
fi

include_pattern=$1
fail_on_changes=$2
files=$3

cd "/github/workspace/" || exit 2
formatted_files_before=$(git status --short)

/opt/idea/bin/format.sh -m $include_pattern -r $files

formatted_files_after=$(git status --short)
formatted_files=$(diff <(echo "$formatted_files_before") <(echo "$formatted_files_after"))
formatted_files_count=$(($(echo "$formatted_files" | wc --lines) - 1))

echo "$formatted_files"
echo "::set-output name=files-changed::$formatted_files_count"

if [[ "$fail_on_changes" == 'true' ]]; then
  if [[ $formatted_files_count -gt 0 ]]; then
    echo 'Failing, because these files changed:'
    exit 1
  fi
fi