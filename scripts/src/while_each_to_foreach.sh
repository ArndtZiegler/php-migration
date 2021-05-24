#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

VARIABLE_NAME="[^, ]*"

for phpFile in "$@"; do
	# Replace while( list($k,$v) = each($arr) ) with foreach( $arr as $k => $v )
	sed -i "s/while\(\s*\)(\s*list\s*(\s*\($VARIABLE_NAME\)\s*,\s*\($VARIABLE_NAME\)\(\s*\))\s*=\s*@*each\s*(\(\s*\)\($VARIABLE_NAME\)\s*)\s*)/foreach\1(\5\6 as \2 => \3\4)/g w /dev/stdout" "$phpFile"
	
	# Correct when no key is used
	sed -i "s/foreach\(\s*\)(\(\s*\)\($VARIABLE_NAME\) as\s*=>\s*\($VARIABLE_NAME\)\(\s*\))/foreach\1(\2\3 as \4\5)/g w /dev/stdout" "$phpFile"
done
