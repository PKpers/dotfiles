import sys
import os
import subprocess
sys.path.insert(0, '/home/kpapad/')#add home directory to system's path
config.load_autoconfig(True)#load autoconfig from config.yml
os.environ["TERMINAL"] = '/usr/bin/alacritty'
userscripts_dir='/home/kpapad/.local/share/qutebrowser/userscripts/'
## Appearence---------------------------------------------------------------------------------------------
## Dracula theme ##
import dracula.draw
config.load_autoconfig()
dracula.draw.blood(c, {
        'spacing': {
            'vertical': 6,
            'horizontal': 8
        }
})
## Load a custom stylesheet ##
'''
--Possible solarized stylesheets--#
darculized/darculized-all-sites.css
solarized-dark/solarized-dark-all-sites
solarized-light/solarized-light-all-sites
apprentice-all-sites.css
~/solarized-everything-css/css/apprentice/apprentice-all-sites.css
'''
#stylesheet="~/solarized-everything-css/css/apprentice/apprentice-all-sites.css"
#c.content.user_stylesheets = stylesheet

#configure status bar
c.statusbar.show = 'in-mode'

#configure tabs
c.tabs.show = 'never'
#when open links in new tabs, focus the new tab
c.tabs.background = False

## Functionallity --------------------------------------------------------------------------------------------------
#configure cookies acceptance 
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')

# Value to send in the `Accept-Language` header. Note that the value
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

# Load images automatically in web pages.
config.set('content.images', True, 'chrome-devtools://*')

# Load images automatically in web pages.
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

#Set emacs as editor and open it when called 
c.editor.command = ["emacsclient", "-c", "{}'"]
#key bindings ----------------------------------------------------------------------------------------------------
#Bindings for normal mode
#open videos with mpv
config.bind('M', 'hint links spawn mpv {hint-url}')
#show hide status bar/tabs
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xx', 'config-cycle tabs.show always never;; config-cycle statusbar.show always never')
#Dark mode togle 
config.bind('I', 'config-cycle colors.webpage.darkmode.enabled true false;; restart')
#save image to specific directory
config.bind('aP', 'hint images spawn --output-messages wget -P "/home/kpapad/Pictures/" {hint-url}')
#view an image in external viewer (full screen / zoom)
config.bind('ap', 'hint images spawn feh {hint-url}')
#open video description in terminal
config.unbind("ad")
config.bind("aD", 'download-cancel')
YTcli=userscripts_dir+'get_yt_info.py'
config.bind('ad', 'hint links spawn alacritty --hold -e '+YTcli +' {hint-url}')
#Org capture link
#captured_links = '/home/kpapad/Documents/qutebrowser/captured_links.org'
#org_capture_links = "hint links spawn yank inline [[{url}][{title}]]"
config.bind('cl', 'hint links spawn --userscript org_capture.py {hint-url}')
translatecli = userscripts_dir+'QB_translate.py'
config.bind('trg', 'spawn alacritty --hold -e python '+translatecli +' el') 
config.bind('tre', 'spawn alacritty --hold -e python '+translatecli +' en') 
