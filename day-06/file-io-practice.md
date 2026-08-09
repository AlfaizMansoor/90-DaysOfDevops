# READ AND WRITE TEXT FILES

- create a file using "touch notes.txt" 
- opens text editor using "vim notes.text", write using "i" and save and quits using ":wq"
- format the file and write using command "echo "line-1" > notes.txt" 
- append new line using "echo "line-2" >> notes.txt"
- appends another line using "tee -a notes.txt" adds line-3 into file notes.txt
- display full file using "cat notes.txt"
- display first 2 line of file notes.txt using "head -n 2 notes.txt"
- display last 2 lines of file notex.txt using "tail -n 2 notes.txt"