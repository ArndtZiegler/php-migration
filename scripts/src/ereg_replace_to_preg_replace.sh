#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

# Special characters occurring in your code
DELIMITERS="[/\!#|~=]"
QUOTES="[\"']"
REGEX_EXPR="[^,]*"
FLAGS="[isSuUme]"
# Concrete special characters you want to replace the old ones with
NEW_DELIMITER="\/"
NEW_QUOTE="\""

for phpFile in "$@"; do
	## Replace ereg{i}_replace with preg_replace (preserving i-flag)
	sed -i "s/\(ereg\|preg\)\([i]\)*_replace(\(\s*\)\($QUOTES\)\($REGEX_EXPR\)$QUOTES\(\s*\),/preg_replace(\3\4$NEW_DELIMITER\5$NEW_DELIMITER\2\4\6,/g w /dev/stdout" "$phpFile"
	sed -i "s/\(ereg\|preg\)\([i]\)*_replace(\(\s*\)\([^\"' ]$REGEX_EXPR\)\(\s*\),/preg_replace(\3$NEW_QUOTE$NEW_DELIMITER$NEW_QUOTE . \4 . $NEW_QUOTE$NEW_DELIMITER\2$NEW_QUOTE\5,/g w /dev/stdout" "$phpFile"

	## Handle comma to dot replacement separately (used e.g. for changing price format)
	sed -i "s/ereg\([i]\)*_replace(\(\s*\)\($QUOTES\)\(,\)$QUOTES\(\s*\),/preg_replace(\2\3$NEW_DELIMITER\4$NEW_DELIMITER\1\3\5,/g w /dev/stdout" "$phpFile"
	
	## Remove double delimiters possibly introduced above
	sed -i "s/preg_replace(\(\s*\)\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS$DELIMITERS$QUOTES\(\s*\),/preg_replace(\1\2\3\4\3\2\5,/g w /dev/stdout" "$phpFile"
	## Move already existing flags after delimiters added by above
	sed -i "s/preg_replace(\(\s*\)\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS\($FLAGS*\)$DELIMITERS\($FLAGS*\)$QUOTES\(\s*\),/preg_replace(\1\2\3\4\3\5\6\2\7,/g w /dev/stdout" "$phpFile"
done

# TODO: Allow commas in regex. Problem: ereg_replace(",",".",$var); ambivalence between comma in regex string and comma as argument separator not decidable with pure regex?
