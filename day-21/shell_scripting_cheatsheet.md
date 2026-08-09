# TASK 1 - Basics

```bash
* Shebang `(#!/bin/bash)`
--> It tells the operating system which interpreter should be used to run the script.

* `chmod +x`
--> It is a command used in OS terminal for changing file permissions._

* `./script.sh`
--> "./file_name.sh" it is used to run a shell script in console.

* `bash script.sh`
--> "bash file_name.sh" it is used to run a shell script in console.

* Single line `(#)`
--> Before writing a comment it is neccesary to write "#" on the starting of line

* Inline
--> Before writing a comment it is neccesary to write "#" on the starting of line, we can write command and comments both together in a single line.

* declaring, using, and quoting ($VAR, "$VAR", '$VAR')
--> `$VAR` :- it is a variable which can stores different values in it, this value is cansider as integer.
`"$VAR"` :- it is a variable which can stores different values in it, this value is cansider as String(any variable in double quote "" stores strings).
`'$VAR'` :- it looks like a variable but not, it is not a variable it written as '$VAR' doesn't hold any value.
#!/bin/bash
VAR="Hello World"
.
echo $VAR      # Output: Hello World
echo "$VAR"    # Output: Hello World
echo '$VAR'    # Output: $VAR

* `read`
--> it is typo used to declare a variable "&VAR" 
read VAR
* Command-line arguments 
--> `$0` :- it is name of the script itself, If your script is called myscript.sh, it prints ./myscript.sh.
--> `$1` :- The first, second, etc. arguments passed to the script.  eg : "$1 = hello"
--> `$#` :-  The number of arguments passed to the script. eg "$# = 3"
--> `$@` :- All arguments as separate words, $@ = one two three (each treated individually)
--> `$?` :- Exit status of the last command (0 = success, non‑zero = error).

```
# TASK 2 - Operators and Conditionals

```bash
* String comparisons :- — =, !=, -z, -n
--> `=`  :- checks if two strings are equal
--> `!=` :- checks if two strings are not equal
--> `-z` :- true if the string is empty
--> `-n` :- true if the string is non-empty
    
* Integer comparisons — -eq, -ne, -lt, -gt, -le, -ge
--> `-eq` :- equal
--> `-ne` :- not equal
--> `-lt` :- less than
--> `-gt` :- greater than
--> `-le` :- less than or equal
--> `-ge` :- greater than or equal

* File test operators — -f, -d, -e, -r, -w, -x, -s
--> `-f` file :- true if file exists and is a regular file
--> `-d` dir :- true if directory exists
--> `-e` file :- true if file exists (any type)
--> `-r` file :- readable
--> `-w` file :- writable
--> `-x` file :- executable
--> `-s` file :- file exists and is not empty

* if, elif, else syntax
--> these are conditional statements or commands, they generate conditions in program and solves a big issue in programing languages
{ x = 10
`if` x > 15:
    print("Greater than 15")
`elif` x == 10:
    print("Equal to 10")
`elif` x > 5:
    print("Greater than 5 but not 10")
`else`:
    print("5 or less")
    }

* Logical operators — &&, ||, !
--> these also are conditional statements like if, else.
* `&&` :- Returns true only if both operands are true.
* `||` :- Returns true if at least one operand is true.
*  `!` :- Negates the boolean value. If the condition is true, it becomes false; if false, it becomes true.

##Case statements — case ... esac
--> In shell scripting (like Bash), the case ... esac statement is used for pattern matching.

```
# TASK 3 - Loops



* for loop — list-based and C-style
--> `for` loop list-style :- Iterates over a list of values (strings, numbers, filenames, etc.), Similar to C/Java style, useful for numeric ranges
--> `while` loop :- Runs as long as the condition is true.
--> `Until` Loop:- Runs until the condition becomes true (opposite of while).
## Loop Control — break and continue
- `break` → exits the loop immediately.
- `continue` → skips the current iteration and moves to the next.
--> Looping Over Files :- Process all .log files in a directory
--> Looping Over Command Output :- Use while read line to process each line of a command’s output.

```

# TASK 4 - Functions

```bash
## Defining a Function 
- we can define a function in two ways
--> `function` greet() {
    echo "message"
}
--> greet() {
    echo "message"
}
## Calling a Function
- Just use the function name:
--> greet

## Passing Arguments to Functions
- Inside a function, arguments are accessed as `$1, $2, $3`, …
`$@` → all arguments, `$#` → number of arguments.

## Return Values — return vs echo
- `return`
Used inside functions in shell scripting.
Ends the function and optionally sends back an integer exit status (0 = success, non‑zero = error).
- `echo`
Prints text to stdout (the terminal or a pipe).
Useful for displaying messages or passing output to another command.

```
# TASK 5 - Text Processing Commands
```bash
## grep — Search Patterns
 - `i` → case‑insensitive search
 - `r` → recursive search in directories
 - `c` → count matching lines
 - `n` → show line numbers
 - `v` → invert match (exclude pattern)
 - `E` → extended regex (like egrep)

## awk
  - `-F` → set field separator (e.g., `-F,` for CSV)
  - `print $1,$2` → print specific columns
  - `/pattern/ {}` → apply only on matching lines
  - `BEGIN {}` / `END {}` → pre/post processing

## sed
  - `s/foo/bar/g` → global substitution
  - `/pattern/d` → delete matching lines
  - `-i` → in‑place edit (direct file modification)

## cut
  - `-d` → delimiter
  - `-f` → fields (columns)

## sort
  - `-n` → numeric sort
  - `-r` → reverse order
  - `-u` → unique (deduplicate)

## uniq
  - `-c` → count occurrences (after `sort`)

## tr
  - `a-z A-Z` → translate lowercase → uppercase
  - `-d` → delete characters

## wc
  - `-l` → line count
  - `-w` → word count
  - `-c` → character count

## head/tail
  - `-n N` → first/last N lines
  - `tail -f` → follow mode (live logs)

```
# TASK 6 - Useful Patterns and One-Liners
```bash
## Find and delete files older than N days
- find /var/log -type f -mtime +7 -delete (Deletes log files older than 7 days.)

## Count lines in all .log files
- wc -l /var/log/*.log (Shows line counts per file.)

## Replace a string across multiple files
- sed -i 's/DEBUG/INFO/g' *.conf (Replaces DEBUG with INFO in all config files)

## Check if a service is running
- systemctl is-active nginx(Returns active if running.)

## Monitor disk usage with alerts
- df -h | awk '$5+0 > 80 {print "ALERT:", $0}' (Prints a warning if any partition exceeds 80% usage)

## Parse CSV or JSON from command line
- `CSV`
awk -F, '{print $1,$3}' data.csv
- `JSON` (with jq):
jq '.users[].name' users.json

## Tail a log and filter for errors in real time
- tail -f /var/log/syslog | grep --line-buffered -i "error" (Live monitoring of errors as they appear.)

```
# TASK 7 - Error Handling and Debugging
```bash
## Exit Codes — `$?, exit 0, exit 1`
- Every command returns an exit code (0 = success, non‑zero = error).
- $? holds the exit code of the last command.
ls /tmp
echo $?
- exit 0 → explicitly exit with success
- exit 1 → explicitly exit with error
  
## `set -e` — Exit on Error
- Makes the script terminate immediately if any command fails.
- set -e
  
## `set -u` — Treat Unset Variables as Error
- Prevents using undefined variables (helps catch typos).
- set -u 
  
## `set -o pipefail` — Catch Errors in Pipes
- Ensures the pipeline fails if any command fails, not just the last one.
- set -o pipefail
- If grep fails (e.g., file missing), the whole pipeline fails.
  
## `set -x` — Debug Mode (Trace Execution)
Prints each command before executing it (like verbose mode).
- set -x
echo "Debugging enabled"
ls /tmp
set +x 

## `trap` — Run Cleanup on Exit
Executes a command or function when the script exits (success or error).
cleanup() {
  echo "Cleaning up temporary files..."
  rm -f /tmp/mytempfile
}
trap cleanup EXIT

```
# TASK 8 - Bonus — Quick Reference Table

```bash

Topic                                        	Key Syntax 	                                              Example
Variable                                    	VAR="value"                                            	NAME="DevOps"
Argument                                      	$1, $2                                            	./script.sh arg1
If 	                                      if [ condition ]; then                               	if [ -f file ]; then
For loop                                    for i in list; do                                  	for i in 1 2 3; do
Function 	                                  name() { ... }                                      	greet() { echo "Hi"; }
Grep 	                                    grep pattern file 	                                    grep -i "error" log.txt
Awk 	                                    awk '{print $1}' file                              	awk -F: '{print $1}' /etc/passwd
Sed                                   	 sed 's/old/new/g' file 	                              sed -i 's/foo/bar/g' config.txt
Cut	                                      cut -d':' -f1 file	                                    cut -d',' -f2 data.csv
Tr                                         	tr 'a-z' 'A-Z'	                                    `echo "hello"	tr 'a-z' 'A-Z'`
Find	                                  find path -name pattern	                                  find . -name "*.sh"
Echo                                        	echo "text"	                                            echo "Hello World"
Read	                                         read var	                                            read name; echo "Hi"
Exit                                         	exit code	                                                 exit 1
Test	                                      [ condition ]	                                   [ -d /etc ] && echo "Dir exists"
Touch	                                     touch filename	                                           touch newfile.txt
Remove	                                    rm filename	                                              rm oldfile.txt
Copy	                                     cp source dest	                                       cp file1.txt backup.txt
Move/Rename	                                mv source dest	                                mv report.txt archive/report.txt
List processes	                                ps aux	                                          `ps aux \	grep python`
Kill process                                 	kill PID	                                                kill 1234
Jobs	                                           jobs	                                                    jobs
Background                                   command &	sleep                                             100 &
Foreground	                                  fg %job	                                                    fg %1
```