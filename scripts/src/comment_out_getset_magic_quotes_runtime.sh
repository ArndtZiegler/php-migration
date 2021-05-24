#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

for phpFile in "$@"; do
	# Kommentiert alle Zeilen aus, die mit set_magic_quotes_runtime beginnen
	sed -i "s/^\(\s*\)set_magic_quotes_runtime/\1\/\/set_magic_quotes_runtime/g w /dev/stdout" "$phpFile"
	# Kommentiert alle Zeilen aus, die mit get_magic_quotes_runtime beginnen
	sed -i "s/^\(\s*\)\([^'\"]*\)get_magic_quotes_runtime/\1\/\/\2get_magic_quotes_runtime/g w /dev/stdout" "$phpFile"
done
