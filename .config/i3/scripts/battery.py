from subprocess import check_output, call
from sys import exit
import sys
#from common import get_color

text = ""
status = check_output(['acpi'], universal_newlines=True) 

splt_stat =status.split(' ') 
percentage = splt_stat[3]
num = percentage.split('%')
battery = float(num[0])
if len(splt_stat) > 4:
    rem_time = splt_stat[4]
#
if 'Full' in status:
    text ='󰁹'+' '+percentage
elif 'Charging' in status:
    if battery > float(75):
        text = '󰂄'+' '+percentage+' '+rem_time
        print(text)
    elif battery <= float(75) and battery>float(50):
        text = '󰂄 '+' '+percentage+' '+rem_time
    elif battery <= float(50) and battery>float(25):
        text ='󰂄 '+' '+percentage+' '+rem_time
    elif battery <= float(25):
        text ='󰂄 '+' '+percentage+' '+rem_time
        print(text)
        
    
elif 'Discharging' in status:
    if battery > float(75):
        text = '󰁹'+' '+percentage+' '+rem_time
    elif battery <= float(75) and battery>float(50):
        text = '󰂀'+' '+percentage+' '+rem_time
    elif battery <= float(50) and battery>float(25):
        text = '󰁾'+' '+percentage+' '+rem_time
    elif battery <= float(25):
        text = '󱃍'+' '+percentage+' '+rem_time
        call(['notify-send', '-u', 'critical', 'LOW BATERY!'])
else:
    text = '󰂑'+' '+percentage

print(text)
