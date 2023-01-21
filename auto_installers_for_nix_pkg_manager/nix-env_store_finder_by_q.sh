#!/usr/bin/env bash

# Get the list of packages
variable_name=($(nix-env -q | awk '{gsub(/-[0-9].*/,"",$0); print $0}'))

# Enumerate the output and print it to the user
i=1
for name in "${variable_name[@]}"; do
    echo "$i) $name"
    i=$((i+1))
done

# Ask the user to select a name
read -p "Select a name by number: " number

# Get the selected name from the enumerated list
selected_name=${variable_name[$((number-1))]}

# Echo the selected number
echo "You have selected $number) $selected_name"

# Change to the /nix/store directory
cd /nix/store

# Use the selected name in a command
#result=$(ls -t | grep -E "^[a-z0-9]{32}-$selected_name$" | head -n 1)
result=$(ls -t | grep -E "^[a-z0-9]{32}-$selected_name(-[0-9]+\.[0-9]+\.[0-9]+)?$"|head -n 1)

echo $result
