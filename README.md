
# Table of Contents

1.  [Dependencies](#org36a57ba)
2.  [Installing the dependecies](#org4652aae)
    1.  [Basic packages from official repositories](#org99ae6bc)
    2.  [other packages that are not in the official repositories](#org3791f19)
        1.  [xkblayout](#org4549555)
        2.  [albert](#org4ef241a)
3.  [Clone the dotfiles](#org40202f6)
4.  [Sytem fonts and theme](#org2420355)
    1.  [Fonts(Icons and text)](#org5fcab3e)
    2.  [Theme, icons and cursors](#org9f9efad)
5.  [Set up Basic components of de](#orgc7d722e)
    1.  [Emacs](#org69b1522)
        1.  [Create the emacs service to start the emacs server](#org2ab0a2e)
        2.  [Install the packages that are not in melpa](#orgdf45f5b)
        3.  [mu4e set up](#org2df69cc)
    2.  [QuteBrowser](#orgf82e913)
        1.  [install the dracula theme](#org0ce0a9b)


<a id="org36a57ba"></a>

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


<a id="org4652aae"></a>

# Installing the dependecies


<a id="org99ae6bc"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install i3 python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="org3791f19"></a>

## other packages that are not in the official repositories


<a id="org4549555"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="org4ef241a"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="org40202f6"></a>

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


<a id="org2420355"></a>

# Sytem fonts and theme


<a id="org5fcab3e"></a>

## Fonts(Icons and text)

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="org9f9efad"></a>

## Theme, icons and cursors

System, icons and cursor themes are configured in `~/.config/gtk-3.0/settings.ini` . Once the dotfiles repo is cloned, one has to just install the fonts so that `setttings.ini` can read them:
\#+begin<sub>src</sub> bash
cd ~
\#System theme installation
mkdir ~/.local/share/themes
git clone <https://github.com/dracula/gtk> ~/.themes/dracula-theme 
\#Icon theme installation
wget -qO- <https://git.io/papirus-icon-theme-install> | DESTDIR="$HOME/.icons" sh
mv ~/.icons ~/.local/share/icons
\#install the cursor theme
cd ~/.themes/dracula-theme/kde/cursors/
chmod a+x build.sh
./build.sh
cp Dracula-cursors ~/.local/share/.icons/


<a id="orgc7d722e"></a>

# Set up Basic components of de


<a id="org69b1522"></a>

## Emacs


<a id="org2ab0a2e"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="orgdf45f5b"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:

    cd ~/.emacs.d
    git clone https://github.com/crocket/dired-single
    git clone https://github.com/emacs-evil/evil-collection
    git clone https://github.com/org-mime/org-mime


<a id="org2df69cc"></a>

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


<a id="orgf82e913"></a>

## QuteBrowser


<a id="org0ce0a9b"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

