
# Table of Contents

1.  [Dependesies](#orgd2a350c)
2.  [Installing the dependecies](#orgc29b8cd)
    1.  [Basic packages from official repositories](#orgaa3d7cf)
    2.  [other packages that are not in the official repositories](#org012bc20)
        1.  [xkblayout](#org5a6eef3)
        2.  [albert](#org2064917)
3.  [Clone the dotfiles](#org5253bc7)
4.  [Configure the fonts in the system](#orgd6d8e57)
5.  [Set up Basic components of de](#org4b687b9)
    1.  [Emacs](#org6e80bc7)
        1.  [Create the emacs service to start the emacs server](#org438f840)
        2.  [Install the packages that are not in melpa](#org98485c9)
        3.  [mu4e set up](#orgc406516)
    2.  [QuteBrowser](#org048fe2a)
        1.  [install the dracula theme](#org05562a9)


<a id="orgd2a350c"></a>

# Dependesies

The following packages are needed: 

-   python(official repositories)
-   xautolock(official repositories)
-   NetworkManager(official repositories)
-   pulseaudio(official repositories)
-   pavucontrol(official repositories)
-   emacs(official repositories)
-   alacritty(official repositories)
-   qutebrowser(official repositories)
-   pcmanfm(official repositories)
-   i3blocks(official repositories)
-   i3lock-fancy-rapid
-   light(official repositories)
-   playerctl(official repositories)
-   screenshot.sh(user program)
-   blueman(official repositories)
-   nitrogen(official repositories)
-   picom(official repositories)
-   albert
-   xf86-input-synaptics(not available for fedora)
-   rclone(official repositories)
-   acpi(official repositories)
-   dunst(official repositories)
-   xkblayout-state-git
-   xprop(official repositories)
-   xset (official repositories)
-   scrot
-   git
-   isync
-   mupdf
-   maildir-utils
-   libtool
-   mpv
-   fonts


<a id="orgc29b8cd"></a>

# Installing the dependecies


<a id="orgaa3d7cf"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="org012bc20"></a>

## other packages that are not in the official repositories


<a id="org5a6eef3"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="org2064917"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="org5253bc7"></a>

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


<a id="orgd6d8e57"></a>

# Configure the fonts in the system

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="org4b687b9"></a>

# Set up Basic components of de


<a id="org6e80bc7"></a>

## Emacs


<a id="org438f840"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="org98485c9"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:
\#+begin<sub>src</sub> bash
cd ~/.emacs.d
git clone <https://github.com/crocket/dired-single>
git clone <https://github.com/emacs-evil/evil-collection>
git clone <https://github.com/org-mime/org-mime>
\#+end<sub>scr</sub>


<a id="orgc406516"></a>

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


<a id="org048fe2a"></a>

## QuteBrowser


<a id="org05562a9"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

