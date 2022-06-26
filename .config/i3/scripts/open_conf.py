from subprocess import check_output, call
from sys import exit
import sys, os

def blockPrint():
    sys.stdout = open(os.devnull, 'w')
#
blockPrint()
call(['emacsclient','-c', '~/.config/i3/config'])
blockPrint()
