#!/bin/bash

# Directory containing the Solidity contract files
CONTRACT_DIR="src"

# Directory to store the generated TypeScript files and Go files
WEB="web"
GO_ABIS="go-abis"
SUBGRAPH="subgraph"
PKG_DIR="pkg"

WEB_DIR="$PKG_DIR/$WEB"
GO_ABIS_DIR="$PKG_DIR/$GO_ABIS"
SUBGRAPH_DIR="$PKG_DIR/$SUBGRAPH"

cleanup() {
    rm -rf $PKG_DIR/*
}

cleanup

# Create the necessary directories
mkdir -p $WEB_DIR
mkdir -p $GO_ABIS_DIR
mkdir -p $SUBGRAPH_DIR

# Function to convert string to snake_case
to_snake_case() {
    echo "$1" | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

# Function to process a single Solidity file
process_file() {
    local contract=$1
    
    # Extract the contract name from the file name
    contract_name=$(basename "$contract" .sol)
    
    # Convert contract name to snake_case
    contract_name_snake=$(to_snake_case "$contract_name")
    
    # Create a subdirectory for the Go file
    go_subdir="$GO_ABIS_DIR/$contract_name_snake"
    mkdir -p $go_subdir

    forge inspect $contract:$contract_name abi > $SUBGRAPH_DIR/$contract_name.json
    if [ $? -ne 0 ]; then
        echo "Forge inspect $contract_name abi failed"
        exit 1
    fi

    forge inspect $contract:$contract_name bytecode > $WEB_DIR/$contract_name.bin
    if [ $? -ne 0 ]; then
        echo "Forge inspect $contract_name bytecode failed"
        exit 1
    fi
    
    abigen --abi $SUBGRAPH_DIR/$contract_name.json --bin $WEB_DIR/$contract_name.bin --pkg $contract_name_snake --type $contract_name --out $go_subdir/${contract_name_snake}.go

    if [ $? -ne 0 ]; then
        echo "Abigen $contract_name failed"
        exit 1
    fi
    
    # Convert JSON to TypeScript (force overwrite) and export the constant
    echo "export const ${contract_name}ABI = $(cat $SUBGRAPH_DIR/$contract_name.json) as const;" > $WEB_DIR/$contract_name.ts
    
    # Remove temporary bin file
    rm $WEB_DIR/$contract_name.bin
    
    echo "Generated Go and TypeScript files for $contract_name"
}

check_command() {
    # 检查 forge
    if ! command -v forge >/dev/null 2>&1; then
        echo "forge command not found"
        exit 1
    fi

    # 检查 abigen
    if ! command -v abigen >/dev/null 2>&1; then
        echo "abigen command not found"
        exit 1
    fi

    if ! command -v zip >/dev/null 2>&1; then
        echo "zip command not found"
        exit 1
    fi
}

# Function to process Solidity files in a directory
process_directory() {
    local dir=$1
    for contract in $dir/*.sol; do
        if [ -f "$contract" ]; then
            process_file "$contract"
        fi
    done
}

# Function to zip directories
zip_directories() {
    (cd $PKG_DIR && zip -r $WEB.zip $WEB && zip -r $GO_ABIS.zip $GO_ABIS && zip -r $SUBGRAPH.zip $SUBGRAPH)
}

check_command

# Process main contract directory
process_directory $CONTRACT_DIR

# Process IAM subdirectory
process_directory $CONTRACT_DIR/IAM

zip_directories

echo "Go file and ABI generation complete"