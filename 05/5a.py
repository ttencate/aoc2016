#!/usr/bin/python3

import hashlib
import sys

door_id = sys.stdin.readline().strip()
index = 0
password = ''

while len(password) < 8:
    hashed = '{0}{1}'.format(door_id, index)
    md5 = hashlib.md5(hashed.encode('ascii')).hexdigest()
    if md5.startswith(5 * '0'):
        char = md5[5]
        password += md5[5]
        print(password)
    index += 1
