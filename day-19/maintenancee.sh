#!/bin/bash

# -e exits on error, -u exits on undefined variables, -o pipefail catches pipeline errors
set -euo pipefail

# Inner function to compress and clean logs
logs() {
    local directory="$1"
    
    if [ -d "$directory" ]; then
        echo -e "Directory $directory exists\n"
        
        echo -e "Compressing .log files from $directory older than 7 days..."
        # Count files first
        count=$(sudo find "$directory" -type f -name "*.log" -mtime +7 | wc -l)
        echo "Found $count files to compress."
        # Safely execute compression
        sudo find "$directory" -type f -name "*.log" -mtime +7 -exec gzip {} \;
        
        echo -e "\nDeleting .gz files from $directory older than 30 days..."
        count=$(sudo find "$directory" -type f -name "*.gz" -mtime +30 | wc -l)
        echo "Found $count files to delete."
        # Safely execute deletion
        sudo find "$directory" -type f -name "*.gz" -mtime +30 -exec rm -f {} \;
    else
        echo "ERROR: Directory $directory does not exist!"
        exit 1
    fi
}

# Inner function to manage backups
back_up() {
    local Source="$1"
    local Destination="$2"

    if [ -d "$Source" ]; then
        echo -e "\nSource directory $Source exists! Starting backup...\n"
        TIMESTAMP=$(date +%Y-%m-%d)
        BACKUP_FILE="${Destination}_${TIMESTAMP}.tar.gz"
        
        # Create the archive safely using sudo in case files inside are restricted
        sudo tar -czf "$BACKUP_FILE" -C "$(dirname "$Source")" "$(basename "$Source")"
        
        echo -e "\nPrinting backup name and size:"
        du -h "$BACKUP_FILE"
        
        echo -e "\nDeleting backups older than 14 days..."
        # Safely locate and delete old tar files in the destination directory
        DEST_DIR=$(dirname "$Destination")
        sudo find "$DEST_DIR" -type f -name "*.tar.gz" -mtime +14 -print -delete | wc -l
    else
        echo -e "\nERROR: Source directory $Source does not exist!"
        exit 1
    fi
}

# Main orchestrator function
maintenance_logs() {
    # Check if the user passed the 2 required arguments to the script
    if [ $# -ne 2 ]; then
        echo "Error: Missing arguments!"
        echo "Usage: $0 <source_directory> <backup_destination_prefix>"
        exit 1
    fi

    local src_dir="$1"
    local dest_prefix="$2"

    echo "=== MAINTENANCE TASK STARTED ==="
    
    # Run the logs function on the requested source folder
    logs "$src_dir"
    
    # Run the backup function with given source and destination paths
    back_up "$src_dir" "$dest_prefix"
    
    echo "=== MAINTENANCE TASK COMPLETED ==="
}

# Execute script and pipe all outputs with a live timestamp directly into the log file
# We pass global script arguments "$@" (which contains your folder inputs) into maintenance_logs
if [ $# -eq 2 ]; then
    maintenance_logs "$1" "$2" 2>&1 | awk '{print "["strftime("%Y-%m-%d %H:%M:%S")"]", $0; fflush()}' >> /var/log/maintenance.log
else
    # Show usage error if executed without arguments
    echo "Error: Missing arguments!"
    echo "Usage: $0 <source_directory> <backup_destination_prefix>"
    exit 1
fi

