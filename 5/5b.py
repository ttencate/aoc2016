#!/usr/bin/python3

import hashlib
import sys

door_id = sys.stdin.readline().strip()
index = 0
password = 8 * [None]

while None in password:
    hashed = '{0}{1}'.format(door_id, index)
    md5 = hashlib.md5(hashed.encode('ascii')).hexdigest()
    if md5.startswith(5 * '0'):
        position = int(md5[5], 16)
        char = md5[6]
        if position < len(password) and not password[position]:
            password[position] = char
            print(''.join(map(lambda c: '_' if c is None else c, password)))
    index += 1
