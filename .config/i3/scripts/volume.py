from subprocess import check_output, call
from sys import exit
import sys
#from common import get_color

def get_sink_id(list_sink, wanted_sink):# get the list wanted sink id out of a list of sinks\
    wanted_sink_id = 0
    for sink in list_sink:
        sink = sink.split('\t')
        if wanted_sink in sink:
            wanted_sink_id = sink[0]# the id is the first element in each sink list
        #
    #
    return wanted_sink_id

def get_volume(sink_id):
    output = []
    command = check_output(
        ['pactl' ,'get-sink-volume', sink_id],
        universal_newlines=True
    )

    command = command.split('\n')
    for c in command:
        if 'Volume' in c:
            line = c.split('dB')
            for l in line:
                l = l.split('%')
                volume = l[0].split('/')
                if volume[-1]=='' : continue
                output.append(int(volume[-1]))
            #
        #
    #
    vol = int(sum(output)/len(output))
    return vol 

def get_status(sink_id):#two possible outcomes: mute, not-mute
    output = check_output(
        ['pactl', 'get-sink-mute',sink_id],
        universal_newlines = True
    )
    status = ''
    if 'yes' in output:
        status = 'mute'
    else:
        status = 'not-mute'
    #
    return status


def get_current_id():
        #get the default sink
        default_sink = check_output(
            ['pactl', 'get-default-sink'], universal_newlines=True
        )
        default_sink = default_sink.split('\n')[0]

        #get the default sink's id
        sinks = check_output(['pactl', 'list', 'sinks', 'short'], universal_newlines=True)
        sinks = sinks.split('\n')
        default_sink_id = get_sink_id(sinks, default_sink)
        return default_sink_id




def print_volume(volume):
    text = ''
    if volume > int(67):
        text = '  '+str(volume)+'%'
        #print(text)
    elif volume <= int(67) and volume > int(34):
        text = ' '+str(volume)+'%'
        #print(text)
    elif volume <= int(34):
        text = ' '+str(volume)+'%'
        #print(text)
    return text



#status_old = ''
#volume_old = ''
#while True:
    
default_sink_id = get_current_id()

try:
    status = get_status(default_sink_id)
    volume = get_volume(default_sink_id)
except Exception:
    default_sink_id = get_current_id()
    status = get_status(default_sink_id)
    volume = get_volume(default_sink_id)
#    
#print output

output_txt = print_volume(volume)
if status == 'mute':
    print('󰖁', flush=True)
else:
    print(output_txt, flush=True)
#print(output_txt)
exit()
'''
if status!=status_old:
    if status == 'mute':
        print('󰖁', flush=True)
    else:
        print(output_txt, flush=True)
    #
            
elif volume!=volume_old and status!='mute':
    print(output_txt, flush=True)
#
#volume_old = volume
#status_old = status
'''    


