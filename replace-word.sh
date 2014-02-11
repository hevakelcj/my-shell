#!/usr/bin/env bash

if [ $# -lt 2 ]; then
    echo "Usage: replace-word <old_name> <new_name>"
    exit
fi

old_name=$1
new_name=$2

echo "replace \"$old_name\" --> \"$new_name\""
file_list=(`grep "$old_name" -R ./ | grep -E '.*\.(cpp|h|CPP|H|c|C):' | awk -F: '{print $1}' | sort | uniq`)

for file in ${file_list[*]}; do
    echo "replace in file: $file"
    sed -i "s/\<$old_name\>/$new_name/g" $file
done

echo "Finished."
