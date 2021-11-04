#!/bin/bash

# Wrapper for the formatter that passes action args and processes the output.
# Required args:
# - Path to base directory.
# - File include glob pattern.
# - Whether to fail on file changes.

if [[ $# -ne 4 ]]; then
  echo 'Exactly three parameters (base dir path, input file pattern, fail on changes, changed files) required.'
  exit 1
fi

base_path=$1
include_pattern=$2
fail_on_changes=$3
changed_files=$4

cd "/github/workspace/$base_path" || exit 2
formatted_files_before=$(git status --short)

/opt/idea/bin/format.sh -m $include_pattern -r $changed_files

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