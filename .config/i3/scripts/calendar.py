from subprocess import check_output, call
from sys import exit
import sys


status = check_output(['cal'],universal_newlines=True)
call(['notify-send', status])

