
# Table of Contents

1.  [Dependencies](#orgfcd7d7c)
2.  [Installing the dependecies](#orgecee3ad)
    1.  [Basic packages from official repositories](#org8fdaa6f)
    2.  [other packages that are not in the official repositories](#org0d2f16a)
        1.  [xkblayout](#org828b53e)
        2.  [albert](#orgb28123f)
3.  [Clone the dotfiles](#org261abf3)
4.  [Sytem fonts and theme](#orgdbd2f21)
    1.  [Fonts(Icons and text)](#org08a9f9d)
    2.  [Theme, icons and cursors](#org931c24c)
5.  [Set up Basic components of de](#org9bd2385)
    1.  [Emacs](#org9a69766)
        1.  [Create the emacs service to start the emacs server](#orgb890df0)
        2.  [Install the packages that are not in melpa](#org762db0d)
        3.  [mu4e set up](#org70572d8)
    2.  [QuteBrowser](#orgcbf2b8f)
        1.  [install the dracula theme](#org5a42fe0)


<a id="orgfcd7d7c"></a>

# Dependencies

The following packages are needed: 

-   python
-   i3
-   xautolock
-   NetworkManager
-   pulseaudio
-   pavucontrol
-   emacs
-   alacritty
-   qutebrowser
-   pcmanfm
-   i3blocks
-   i3lock-fancy-rapid
-   light
-   playerctl
-   blueman
-   nitrogen
-   picom
-   albert
-   xf86-input-synaptics(not available for fedora)
-   rclone
-   acpi
-   dunst
-   xkblayout-state-git
-   xprop
-   xset
-   scrot
-   git
-   isync
-   mupdf
-   maildir-utils
-   libtool
-   mpv
-   fonts


<a id="orgecee3ad"></a>

# Installing the dependecies


<a id="org8fdaa6f"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install i3 python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="org0d2f16a"></a>

## other packages that are not in the official repositories


<a id="org828b53e"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="orgb28123f"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="org261abf3"></a>

# Clone the dotfiles

Using a git bare repositoriy, so that I will be able to manage dotfiles more easily.
More on this here: [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

    #!/bin/bash
    #create the  directory to host the bare repostitory
    mkdir .dotfiles
    #
    echo  "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> .bashrc
    git clone --bare https://github.com/PKpers/dotfiles $HOME/.dotfiles
    function config {
       /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
    }
    mkdir -p .config-backup
    config checkout
    if [ $? = 0 ]; then
        echo "Checked out config.";
    else
        echo "Backing up pre-existing dot files.";
        config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;
    config checkout
    config config status.showUntrackedFiles no


<a id="orgdbd2f21"></a>

# Sytem fonts and theme


<a id="org08a9f9d"></a>

## Fonts(Icons and text)

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="org931c24c"></a>

## Theme, icons and cursors

System, icons and cursor themes are configured in `~/.config/gtk-3.0/settings.ini` . Once the dotfiles repo is cloned, one has to just install the fonts so that `setttings.ini` can read them:

    cd ~
    #System theme installation
    mkdir ~/.local/share/themes
    git clone https://github.com/dracula/gtk ~/.themes/dracula-theme 
    #Icon theme installation
    wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.icons" sh
    mv ~/.icons ~/.local/share/icons
    #install the cursor theme
    cd ~/.themes/dracula-theme/kde/cursors/
    chmod a+x build.sh
    ./build.sh
    cp Dracula-cursors ~/.local/share/.icons/


<a id="org9bd2385"></a>

# Set up Basic components of de


<a id="org9a69766"></a>

## Emacs


<a id="orgb890df0"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="org762db0d"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:

    cd ~/.emacs.d
    git clone https://github.com/crocket/dired-single
    git clone https://github.com/emacs-evil/evil-collection
    git clone https://github.com/org-mime/org-mime


<a id="org70572d8"></a>

### mu4e set up

script that sets mu4e up. More about mu4e can be found here: [Emacs-mail](https://github.com/daviwil/emacs-from-scratch/blob/629aec3dbdffe99e2c361ffd10bd6727555a3bd3/show-notes/Emacs-Mail-01.org)

    #Prepare the enviroment
    cd ~
    echo "Please enter your email address"
    read email
    echo "please enter you email password"
    read password
    echo "$password" >> ~/.pswd #put password to this folder so mbsync can read it 
    mkdir -p ~/Mail/Gmail/Inbox #Create the directories where the mail will be stored 
    #Start the initial sync
    mbsync -a
    #Setting up mu to index the mailbox
    mu init --maildir=~/Mail --my-address="$email"
    mu index


<a id="orgcbf2b8f"></a>

## QuteBrowser


<a id="org5a42fe0"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

