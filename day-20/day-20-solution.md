# Day 20 Solution: Log Analyzer and Report Generator

## Approach

I implemented a Bash script at `day_20/log_analyzer.sh` that automates log analysis and report generation.

- Task 1: Input validation
  - The script accepts a single command-line argument for the log file path.
  - It exits with a clear error if no argument is provided or if the file does not exist.
- Task 2: Error count
  - It counts lines containing `ERROR` or `Failed` using `grep -E`.
  - It prints the total error count to the console.
- Task 3: Critical events
  - It searches for lines containing `CRITICAL` with `grep -n`.
  - It prints each matching line with its line number.
- Task 4: Top error messages
  - It extracts `ERROR` lines and removes the timestamp/level portion.
  - It uses `sort`, `uniq -c`, and `sort -rn` to find the top 5 most common messages.
- Task 5: Summary report
  - It writes a summary file named `log_report_<date>.txt`.
  - The report includes analysis date, log file name, total lines, error count, top errors, and critical events.
- Task 6 (optional): Archive processed logs
  - It creates an `archive/` directory if needed.
  - It moves the processed log file into `archive/` after analysis.

## Commands and tools used

- `bash`
- `grep`
- `awk`
- `sort`
- `uniq`
- `wc`
- `date`
- `mkdir`
- `mv`

## Sample output

Console output from a sample run:

```bash
Total error count: 0

--- Critical Events ---
No critical events found.

--- Top 5 Error Messages ---
No ERROR messages found.

Summary report written to log_report_2026-08-08.txt
Processed log file moved to archive/
```

Generated report file: `day_20/log_report_2026-08-08.txt`

## What I learned

- How to validate script input and handle missing files cleanly.
- How to use `grep`, `awk`, and `sort` together to identify the most common error messages.
- How to generate a timestamped report file and archive processed logs automatically.
