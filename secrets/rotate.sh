#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

if [ $# -gt 0 ]; then
    files=("$@")
else
    files=(*.age)
fi

for file in "${files[@]}"; do
    # Skip if file does not exist
    [ -e "$file" ] || continue

    read -r -p "Do you want to rotate $file? (y/N) " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        read -r -s -p "Enter new value for $file: " new_val
        echo
        
        # We pass the newly entered value securely via an environment variable
        export NEW_SECRET_VALUE="$new_val"
        
        # We override EDITOR so agenix uses our script to just write the new value into the temporary decrypted file
        export EDITOR='sh -c '\''echo -n "$NEW_SECRET_VALUE" > "$1"'\'' --'
        
        echo "Rotating $file..."
        agenix -e "$file"
        
        # Securely overwrite and unset the sensitive variables from memory
        new_val="0000000000000000000000000000000000000000"
        NEW_SECRET_VALUE="0000000000000000000000000000000000000000"
        unset new_val
        unset NEW_SECRET_VALUE
        
        echo "Successfully rotated $file."
        echo
    else
        echo "Skipping $file..."
        echo
    fi
done

