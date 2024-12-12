#!/bin/bash

# $1 - path for cleaning, ex "/data/pg/14/jira/archivelog/"
# $2 - treshold, ex 10

path_to_check="/data" # Path for checking
archivelog_directory=$1
threshold=$2 # treshold percent for check

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_tor_cleaning> <threshold>"
    exit 1
fi

# Checking % free space
check_disk_usage() {
    df_output=$(df -h "$path_to_check" | awk 'NR==2 {print $5}')
    df_output=${df_output%?} # Usunięcie znaku '%'
    echo "$df_output"
}

# Clearing space for archvielog_directory
clear_directory() {
    if [ -d "$archivelog_directory" ]; then
        find "$archivelog_directory" -mindepth 1 -delete
    fi
}

free_space_percentage=$(check_disk_usage)

echo "Free space: ${free_space_percentage}%"

if [ "$free_space_percentage" -lt "$threshold" ]; then
    echo "Free space is below ${threshold}%, clearing directory: ${archivelog_directory}"
    clear_directory
else
    echo "Free space is sufficient."
fi