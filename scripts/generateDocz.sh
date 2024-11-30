#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: No argument supplied. Please provide a module name."
    exit 1
fi

MODULE="$1"

lemmy-help \
  --layout compact:0 \
  --indent 2 \
  -f -t -a -c \
  ./lua/${MODULE}/init.lua \
  >doc/${MODULE}.txt
