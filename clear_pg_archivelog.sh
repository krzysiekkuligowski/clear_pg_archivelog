#!/bin/bash

# Patch for checking
path_to_check="/data"
archivelog_directory="/data/pg/14/test1/archivelog"

# treshold percent for check
threshold=10

# Checking % free space
check_disk_usage() {
    df_output=$(df -h "$path_to_check" | awk 'NR==2 {print $5}')
    df_output=${df_output%?} # Usunięcie znaku '%'
    echo "$df_output"
}

# Clearing space for archvielog_directory
clear_directory() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -mindepth 1 -delete
    fi
}

free_space_percentage=$(check_disk_usage)

echo "Free space: ${free_space_percentage}%"

if [ "$free_space_percentage" -lt "$threshold" ]; then
    echo "Free space is below ${threshold}%, clearing directory: ${archivelog_directory}"
    clear_directory "$archivelog_directory"
else
    echo "Free space is sufficient."
fi