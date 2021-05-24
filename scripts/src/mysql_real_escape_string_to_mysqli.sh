#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

MY_DB_LINK="\$db"

for phpFile in "$@"; do
	sed -i "s/mysql_real_escape_string(\([^)]*\))/mysqli_real_escape_string($MY_DB_LINK, \1)/g w /dev/stdout" "$phpFile"
done
