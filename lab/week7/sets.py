#!/usr/bin/env python

import sys
import re

def main(args=None):
    if len(args) != 2:
        print("Please provide two files")
        sys.exit()

    (file1, file2) = args

    nonword = re.compile('\W')
    words1 = get_words(file1)
    words2 = get_words(file2)

    common = sorted(words1.intersection(words2))
    print("\n".join(common))
    print("Found %s words in common." % len(common))

def get_words(file):
    words = set()
    for line in open(file, 'r').read().splitlines():
        for word in line.split():
            words.add(re.sub(r'[^A-Za-z0-9]', '', word).lower())
    return words

if __name__ == '__main__': 
    main(sys.argv[1:])
