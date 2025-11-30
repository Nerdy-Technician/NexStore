#!/bin/bash
# @name: Largest files
# @description: A script to find the 10 largest files on the system.

@NEXTERM:STEP "Finding the 10 largest unique files on the system"

largest_files=$(find / \
  \( -path /proc -o -path /sys -o -path /dev -o -path /tmp -o -path /run -o -path /var/run \) -prune -o \
  -type f -printf '%s %p\n' 2>/dev/null \
  | sort -nr \
  | awk '!seen[$2]++' \
  | head -n 10 \
  | awk '{printf "\"%s,%.2fMB\" ", $2, $1/1024/1024}')

@NEXTERM:TABLE "Top 10 Largest Files" "File Path,Size (MB)" $largest_files