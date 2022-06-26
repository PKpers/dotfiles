#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kpapad/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kpapad/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kpapad/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kpapad/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

## Aliases ##
#custom ls
alias ls='ls -ltarh --color=auto'
#clear screen 
alias cls='clear'
alias csl='clear'
alias lcs='clear'
alias lsc='clear'
alias slc='clear'
alias scl='clear'
#exit terminal
alias q='exit'
#open lackey, a terminal calendar, with a more intuitive name 
alias calendar='lackey'
#compile and run c++ code
alias cnr='run'
#use ytfzf by typing a smaller and easier command
alias yt='ytfzf'
#activate virtual envs with a smaller command
alias ca='conda activate'
#activate the webcam
alias camera='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'
#alias for nerofetch
alias nf='neofetch'
#gupload is way to big to write it every time
alias gu='gupload'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
## Locale settings ##
#export LC_ALL=el_GR.UTF-8

## $PATH settings ##
export PATH=/home/kpapad/.local/bin:$PATH
