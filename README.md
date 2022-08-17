
# Table of Contents

1.  [Dependencies](#orgc45a57b)
2.  [Installing the dependecies](#org7731159)
    1.  [Basic packages from official repositories](#orga1e7ca4)
    2.  [other packages that are not in the official repositories](#org9186623)
        1.  [xkblayout](#org72d22f5)
        2.  [albert](#org69f8dfe)
3.  [Clone the dotfiles](#org538abf6)
4.  [Configure the fonts in the system](#org77f44f9)
5.  [Set up Basic components of de](#org8799908)
    1.  [Emacs](#org0ff2214)
        1.  [Create the emacs service to start the emacs server](#org831c5e3)
        2.  [Install the packages that are not in melpa](#orga0918be)
        3.  [mu4e set up](#org1510bc7)
    2.  [QuteBrowser](#orgf72bf91)
        1.  [install the dracula theme](#org699c13b)


<a id="orgc45a57b"></a>

# Dependencies

The following packages are needed: 

-   python
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


<a id="org7731159"></a>

# Installing the dependecies


<a id="orga1e7ca4"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="org9186623"></a>

## other packages that are not in the official repositories


<a id="org72d22f5"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="org69f8dfe"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="org538abf6"></a>

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


<a id="org77f44f9"></a>

# Configure the fonts in the system

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="org8799908"></a>

# Set up Basic components of de


<a id="org0ff2214"></a>

## Emacs


<a id="org831c5e3"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="orga0918be"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:

    cd ~/.emacs.d
    git clone https://github.com/crocket/dired-single
    git clone https://github.com/emacs-evil/evil-collection
    git clone https://github.com/org-mime/org-mime


<a id="org1510bc7"></a>

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


<a id="orgf72bf91"></a>

## QuteBrowser


<a id="org699c13b"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

