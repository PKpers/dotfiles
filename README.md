
# Table of Contents

1.  [Dependencies](#orgc75b9cb)
2.  [Installing the dependecies](#org44c8692)
    1.  [Basic packages from official repositories](#orga9771db)
    2.  [other packages that are not in the official repositories](#org1a89f2a)
        1.  [xkblayout](#orgf60081e)
        2.  [albert](#org48de65c)
3.  [Clone the dotfiles](#orgb1c0afe)
4.  [Configure the fonts in the system](#org6f77911)
5.  [Set up Basic components of de](#orgdd996b4)
    1.  [Emacs](#org7434724)
        1.  [Create the emacs service to start the emacs server](#org2fd16f6)
        2.  [Install the packages that are not in melpa](#org47307a4)
        3.  [mu4e set up](#orge56e1a5)
    2.  [QuteBrowser](#orgda538e3)
        1.  [install the dracula theme](#org2f89424)


<a id="orgc75b9cb"></a>

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
-   screenshot.sh
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


<a id="org44c8692"></a>

# Installing the dependecies


<a id="orga9771db"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="org1a89f2a"></a>

## other packages that are not in the official repositories


<a id="orgf60081e"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="org48de65c"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="orgb1c0afe"></a>

# Clone the dotfiles

Using a git bare repositoriy, so that I will be able to manage dotfiles more easily.
More on this here: [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

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


<a id="org6f77911"></a>

# Configure the fonts in the system

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="orgdd996b4"></a>

# Set up Basic components of de


<a id="org7434724"></a>

## Emacs


<a id="org2fd16f6"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="org47307a4"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:

    cd ~/.emacs.d
    git clone https://github.com/crocket/dired-single
    git clone https://github.com/emacs-evil/evil-collection
    git clone https://github.com/org-mime/org-mime


<a id="orge56e1a5"></a>

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


<a id="orgda538e3"></a>

## QuteBrowser


<a id="org2f89424"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

