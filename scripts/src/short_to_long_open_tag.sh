#!/bin/bash
# Copyright (c) 2020 Arndt H. Ziegler <code@arndtziegler.de>

for phpFile in "$@"; do
	sed -i "s/<?\r/<?php\r/g w /dev/stdout" "$phpFile"
	sed -i "s/<?$/<?php/g w /dev/stdout" "$phpFile"
	sed -i "s/<?\([^=pPxX]\)/<?php\1/g w /dev/stdout" "$phpFile"
done
