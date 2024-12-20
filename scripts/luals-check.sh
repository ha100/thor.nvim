#!/bin/sh

# Performs a lua-language-server check on all files.
# luals-out/check.json will be produced on any issues, returning 1.
# Outputs only check.json to stdout, all other messages to stderr, to allow jq etc.

DIR_SRC="lua"
DIR_OUT=".build/luals-out"

# clear output
rm -rf "${DIR_OUT}"
mkdir "${DIR_OUT}"

# execute inside lua to prevent luals itself from being checked
OUT=$(lua-language-server --check="${DIR_SRC}" --configpath="${PWD}/.luarc.json" --checklevel=Information --logpath="${DIR_OUT}" --loglevel=error)
RC=$?

echo "${OUT}" >&2

if [ $RC -ne 0 ]; then
  echo "failed with RC=$RC"
  exit $RC
fi

# any output is a fail
case "${OUT}" in
  *Diagnosis\ complete*)
    if [ -f "${DIR_OUT}/check.json" ]; then
      json=$(cat "${DIR_OUT}/check.json")
      if [ "$json" != "[]" ]; then
        echo "${json}"
        exit 1
      else
        exit 0
      fi
    else
      exit 0
    fi
    ;;
  *)
    exit 1
    ;;
esac
