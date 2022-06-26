from subprocess import check_output, call
from sys import exit
import sys

def get_name(net_output, window_id ): #net_output: list of possible xprop outputs
    try:
        output = check_output(['xprop', '-id', window_id],universal_newlines=True)
        lines = output.split('\n')
        query = str(net_output)

        for l in lines:
            if query in l:
                window_name = l
            #
        #
        window_name = window_name.split('=')
        window_name = window_name[1]
    except Exception:
        window_name = ''
    #
    return window_name

#old_name = ''
#while True:
try:
    id_ = check_output(
        ['xprop', '-root', '_NET_ACTIVE_WINDOW'],
        universal_newlines=True
    )
    id_ = id_.split(' ')[4]
    name = get_name('_NET_WM_NAME', id_)
except Exception:
    name = ''
#
print(name,'=[ ]', flush=True)
#if name != old_name:
    
#
#old_name = name
