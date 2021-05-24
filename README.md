# PHP Migration 5.x to 7.4
In the wake of the major version jump from PHP5 to PHP7 many built-in functions and extension were deprecated or removed.
Many legacy projects still run on PHP5.x, where these features are widely used and therefore expensive to replace, even more so in the absence of automated tests and clean code. 

The provided bash scripts were written and tested by the author during the migrations of two middle-sized PHP projects that now run at PHP7.4 in production. They are meant to yield quick results and generate error-free code in most cases. Since they are regex-based, they may produce faulty syntax in some edge cases. The `scripts/tests/` folder contains test cases for each script, with which their behavior can be validated.

These scripts only replace deprecated or removed features to allow the code to be executed at PHP7.4. They do not improve the code or utilize new language features beyond the recommended replacements for the deprecations at hand. 

## Usage

To apply a script (e.g. `ereg_to_preg_replace.sh`) to a PHP file, simply run
```
bash scripts/src/ereg_to_preg_replace.sh your-file.php
```
The scripts also accept multiple files:
```
bash scripts/src/ereg_to_preg_replace.sh your-src/*
```

## Tests

A script (e.g. `mysql_to_mysqli.sh`) is tested by providing an input and an expected result in two files, `mysql_to_mysqli.test` and `mysql_to_mysqli.expected`, respectively, at the same line. Each line contains an independent test case. To test all scripts, run
```
cd scripts;
bash testScripts.sh tests/ src/*
```