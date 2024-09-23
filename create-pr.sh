#!/usr/bin/env bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "No argument provided."
  exit 1
fi

# Print the first argument
echo "Payload: $1"