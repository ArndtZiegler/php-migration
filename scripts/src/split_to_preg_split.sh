#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

# Special characters occurring in your code
DELIMITERS="[/\!#|~=]"
QUOTES="[\"']"
REGEX_EXPR=".*" # [^,]*
FLAGS="[isSuUme]"
# Concrete special characters you want to replace the old ones with
NEW_DELIMITER="\/"
NEW_QUOTE="\""

for phpFile in "$@"; do
	# Replace split with preg_split
	sed -i "s/split(\s*\($QUOTES\)\($REGEX_EXPR\)$QUOTES\s*,/preg_split(\1$NEW_DELIMITER\2$NEW_DELIMITER\1,/g w /dev/stdout" "$phpFile"
	sed -i "s/\([^_]\)split(\s*\([^\"']$REGEX_EXPR\)\s*,/\1preg_split($NEW_QUOTE$NEW_DELIMITER$NEW_QUOTE . \2 . $NEW_QUOTE$NEW_DELIMITER$NEW_QUOTE,/g w /dev/stdout" "$phpFile"

	## Remove double delimiters possibly introduced above
	sed -i "s/preg_split(\s*\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS$DELIMITERS$QUOTES\s*,/preg_split(\1\2\3\2\1,/g w /dev/stdout" "$phpFile"
	## Move already existing flags after delimiters added by above
	sed -i "s/preg_split(\s*\($QUOTES\)$DELIMITERS\($DELIMITERS\)\($REGEX_EXPR\)$DELIMITERS\($FLAGS*\)$DELIMITERS$QUOTES\s*,/preg_split(\1\2\3\2\4\1,/g w /dev/stdout" "$phpFile"
	## Remove double "preg" possibly introduced above
	sed -i "s/\(preg_\)*preg_split/preg_split/g w /dev/stdout" "$phpFile"
done
