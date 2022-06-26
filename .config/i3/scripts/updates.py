from subprocess import check_output, call
from sys import exit
import sys

try:
    status = check_output(['pacman', '-Qu'],universal_newlines=True)

    update = 0
    for s in status:
        if s == '\n': update += 1
    #
    if update == 0:
        print(' '+'system is up to date')
    else:
        print('',update, 'updates')
    #
except Exception:
    print(' '+'system is up to date')
#
