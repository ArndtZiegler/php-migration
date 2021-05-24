#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

for phpFile in "$@"; do
	# Replace basic name
	sed -i "s/mysql/mysqli/g" "$phpFile"
	sed -i "s/mysqlii/mysqli/g" "$phpFile"
	# Swap arguments (db link now needs to be first argument)
	sed -i "s/mysqli_query(\(.*\),[ ]*\([^) ]*\))/mysqli_query(\2, \1)/g w /dev/stdout" "$phpFile"
	sed -i "s/mysqli_select_db(\(.*\),\([^)]*\))/mysqli_select_db(\2, \1)/g w /dev/stdout" "$phpFile"
done
