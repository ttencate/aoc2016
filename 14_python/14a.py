#!/usr/bin/python3

import hashlib
import sys

def repeating_chars(hash, count):
    char = None
    seen = 0
    for c in hash:
        if c == char:
            seen += 1
            if seen == 3:
                return char
        else:
            char = c
            seen = 1
    return None

salt = sys.stdin.readline().strip()
index = 0
hashes = []
keys = []

while len(keys) < 64:
    hashed = '{0}{1}'.format(salt, index)
    md5 = hashlib.md5(hashed.encode('ascii')).hexdigest()
    hashes.append(md5)
    if len(hashes) > 1000:
        candidate = hashes[-1001]
        r = repeating_chars(candidate, 3)
        if r:
            needle = r * 5
            for hash in hashes[-1000:]:
                if needle in hash:
                    keys.append(hash)
                    break
    index += 1
print(len(hashes) - 1001)
