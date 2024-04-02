#!/bin/bash

# Loop through all directories under ./
for directory in ./*; do
    if [ -d "$directory" ]; then
        directory_name=$(basename "$directory")
        
        helm install --dry-run "$directory_name" "$directory" > "$HOME"/free5GC/free5gc-helm/charts/free5gc/dry_run/"$directory_name".yaml
    fi
done
