#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

# Usage
if [ $# -lt 2 ]
then
  echo "Usage: bash $0 /path/to/test/files/folder/ scripts_to_test.sh"
  exit 1
fi

# Initialize
testFilesDir=$1
parameters=( "$@" )
unset 'parameters[0]'
scriptsToTest=("${parameters[@]}")
totalTests=0
failedTests=0

# Test given scripts against their test files
for scriptToTest in "${scriptsToTest[@]}"
do
  totalTests=$((totalTests + 1))

  ## Setup involved files
  truncatedScriptFile=${scriptToTest//src\//}
  testFile="$testFilesDir${truncatedScriptFile//\.sh/.test}"
  tmpTestFile="$testFile"".tmp"
  expectedFile="${testFile//\.test/.expected}"
  if ! [ -f "$testFile" ] || ! [ -f "$expectedFile" ]
  then
    echo "[*] ERROR (""$scriptToTest""): test files not found"
    failedTests=$((failedTests + 1))
    continue
  fi

  ## Apply script to copy of its test file
  cp "$testFile" "$tmpTestFile"
  bash "$scriptToTest" "$tmpTestFile" > /dev/null

  ## Assert actual and expected are the same
  difference=$(diff -u "$tmpTestFile" "$expectedFile")
  if [ "$difference" != "" ]
  then
    echo "[*] ERROR (""$scriptToTest""):"
    echo "$difference"
    failedTests=$((failedTests + 1))
  fi

  ## Clean up
  rm "$tmpTestFile"
done

# Print results
echo "[*] Tests passed: "$((totalTests - failedTests))"/"$totalTests
if [ $failedTests == 0 ]
then
  echo "[*] OK"
fi
