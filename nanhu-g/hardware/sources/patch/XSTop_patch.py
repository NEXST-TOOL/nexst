#!/usr/bin/env python3

import sys
import re

filename = sys.argv[1]

in_block = False

with open(filename, 'r') as f:
    while f:
        line = f.readline()
        if not line:
            break

        if not in_block:
            if re.match('^\W*DebugModule debugModule.*$', line):
                in_block = True

        if in_block:
            sys.stdout.write('//' + line)
        else:
            sys.stdout.write(line)

        if in_block:
            if re.match('^\W*\);\W*$', line):
                in_block = False
