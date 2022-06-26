from subprocess import check_output, call
from sys import exit
import sys


status = check_output(['xkblayout-state', 'print', '%s'],universal_newlines=True)
print(status)
