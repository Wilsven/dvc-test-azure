#!/bin/bash

# Define the directory to be checked
DIR="data/01_raw"

# Check if the directory exists
if [ -d "$DIR" ]; then
  echo "Checking directory: $DIR"

  # Find and remove Excel files (*.xls and *.xlsx)
  find "$DIR" -type f \( -name "*.xls" -o -name "*.xlsx" \) -print -exec rm -f {} \;
  echo "Removed all Excel files."

  # Find and remove all directories within the specified directory
  find "$DIR" -mindepth 1 -type d -print -exec rm -rf {} +;
  echo "Removed all directories within $DIR."

else
  echo "Directory $DIR does not exist."
fi