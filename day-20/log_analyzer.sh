#!/usr/bin/env bash
set -euo pipefail

log_file="${1:-}"

if [[ -z "$log_file" ]]; then
  echo "Error: No log file provided. Usage: $0 <log_file>" >&2
  exit 1
fi

if [[ ! -f "$log_file" ]]; then
  echo "Error: Log file '$log_file' does not exist." >&2
  exit 1
fi

total_lines=$(wc -l < "$log_file")
error_count=$(grep -E 'ERROR|Failed' "$log_file" | wc -l || true)
critical_lines=$(grep -n 'CRITICAL' "$log_file" | awk -F':' '{print "Line " $1 ": " substr($0, index($0,$2))}' || true)

top_errors=$(grep 'ERROR' "$log_file" | awk '{ msg = $0; sub(/.*ERROR[[:space:]]*/, "", msg); if (msg != "") print msg }' | sort | uniq -c | sort -rn | head -n 5 | awk '{ count=$1; $1=""; sub(/^ +/, ""); print count " " $0 }' || true)

printf 'Total error count: %s\n' "$error_count"
printf '\n--- Critical Events ---\n'
if [[ -n "$critical_lines" ]]; then
  printf '%s\n' "$critical_lines"
else
  echo 'No critical events found.'
fi

printf '\n--- Top 5 Error Messages ---\n'
if [[ -n "$top_errors" ]]; then
  printf '%s\n' "$top_errors"
else
  echo 'No ERROR messages found.'
fi

report_date=$(date '+%F')
report_file="log_report_${report_date}.txt"
{
  printf 'Date of analysis: %s\n' "$report_date"
  printf 'Log file name: %s\n' "$(basename "$log_file")"
  printf 'Total lines processed: %s\n' "$total_lines"
  printf 'Total error count: %s\n' "$error_count"
  printf '\nTop 5 Error Messages:\n'
  if [[ -n "$top_errors" ]]; then
    printf '%s\n' "$top_errors"
  else
    echo 'No ERROR messages found.'
  fi
  printf '\nCritical Events:\n'
  if [[ -n "$critical_lines" ]]; then
    printf '%s\n' "$critical_lines"
  else
    echo 'No critical events found.'
  fi
} > "$report_file"

printf '\nSummary report written to %s\n' "$report_file"

archive_dir="archive"
mkdir -p "$archive_dir"
mv "$log_file" "$archive_dir/"
printf 'Processed log file moved to %s/\n' "$archive_dir"
