#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

# Special characters occurring in your code
DELIMITERS="[/\!#|~=]"
QUOTES="[\"']"
REGEX_EXPR=".*" # or use [^,]*
FLAGS="[isSuUme]"
# Concrete special characters you want to replace the old ones with
NEW_DELIMITER="\/"
NEW_QUOTE="\""

for phpFile in "$@"; do
	## Replace ereg{i} with preg_match (preserving i-flag)
	sed -i "s/ereg\([i]\)*(\(\s*\)\($QUOTES\)\($REGEX_EXPR\)$QUOTES\(\s*\),/preg_match(\2\3$NEW_DELIMITER\4$NEW_DELIMITER\1\3\5,/g w /dev/stdout" "$phpFile"
	sed -i "s/ereg\([i]\)*(\(\s*\)\($REGEX_EXPR\)\(\s*\),/preg_match(\2$NEW_QUOTE$NEW_DELIMITER$NEW_QUOTE . \3 . $NEW_QUOTE$NEW_DELIMITER\1$NEW_QUOTE\4,/g w /dev/stdout" "$phpFile"
	
	## Remove double delimiters possibly introduced above
	sed -i "s/preg_match(\(\s*\)\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS$DELIMITERS$QUOTES\(\s*\),/preg_match(\1\2\3\4\3\2\5,/g w /dev/stdout" "$phpFile"
	## Move already existing flags after delimiters added by above
	sed -i "s/preg_match(\(\s*\)\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS\($FLAGS*\)$DELIMITERS\($FLAGS*\)$QUOTES\(\s*\),/preg_match(\1\2\3\4\3\5\6\2\7,/g w /dev/stdout" "$phpFile"
done

# TODO: siehe ereg_replace_to_preg_replace.sh
