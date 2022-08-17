
# Table of Contents

1.  [Dependesies](#orgcb54ea3)
2.  [Installing the dependecies](#org4a07784)
    1.  [Basic packages from official repositories](#org11562d2)
    2.  [other packages that are not in the official repositories](#orga105d19)
        1.  [xkblayout](#orge44429a)
        2.  [albert](#org404b365)
3.  [Clone the dotfiles](#orgdf235d2)
4.  [Configure the fonts in the system](#orgfc84cfe)
5.  [Set up Basic components of de](#orgbad9c37)
    1.  [Emacs](#orga38494c)
        1.  [Create the emacs service to start the emacs server](#org9be5305)
        2.  [Install the packages that are not in melpa](#orgaffbc3b)
        3.  [mu4e set up](#org9f3bf15)
    2.  [QuteBrowser](#org7aba110)
        1.  [install the dracula theme](#org84c6184)


<a id="orgcb54ea3"></a>

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


<a id="org4a07784"></a>

# Installing the dependecies


<a id="org11562d2"></a>

## Basic packages from official repositories

Run the following **as root**. Replace `dnf install` with the package manager command of the distro in use.

    # run this as sudo
    dnf install python xautolock NetworkManager pulseaudio pavucontrol emacs alacritty qutebrowser pcmanfm i3blocks light playerctl blueman nitrogen picom albert rclone acpi dunst xprop xset scrot git mupdf isync mu4e libtool libvterm mpv


<a id="orga105d19"></a>

## other packages that are not in the official repositories


<a id="orge44429a"></a>

### xkblayout

To install xkblayout run the following **as root**

    git clone https://github.com/nonpop/xkblayout-state
    cd xkblayout-state
    make
    cp ~/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state


<a id="org404b365"></a>

### albert

To install albert launcher follow  [the instructions](https://albertlauncher.github.io/installing/) on their webpage


<a id="orgdf235d2"></a>

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


<a id="orgfc84cfe"></a>

# Configure the fonts in the system

Fonts folder is in the repo so when the config-install script runs, fonts are downloaded and placed in the correct path.


<a id="orgbad9c37"></a>

# Set up Basic components of de


<a id="orga38494c"></a>

## Emacs


<a id="org9be5305"></a>

### Create the emacs service to start the emacs server

To install the service do the following, **Not as root:**

    cd ~
    cp ~/services/emacs.service ~/.config/systemd/user/emacs.service
    systemctl enable --user emacs
    systemctl start --user emacs

More about emacs service: [Emacs as Daemon](https://www.emacswiki.org/emacs/EmacsAsDaemon)


<a id="orgaffbc3b"></a>

### Install the packages that are not in melpa

To install the packages that are not in melpa, simply do:
\#+begin<sub>src</sub> bash
cd ~/.emacs.d
git clone <https://github.com/crocket/dired-single>
git clone <https://github.com/emacs-evil/evil-collection>
git clone <https://github.com/org-mime/org-mime>
\#+end<sub>scr</sub>


<a id="org9f3bf15"></a>

### mu4e set up

script that sets mu4e up. More about mu4e can be found here: [Emacs-mail](https://github.com/daviwil/emacs-from-scratch/blob/629aec3dbdffe99e2c361ffd10bd6727555a3bd3/show-notes/Emacs-Mail-01.org)
\#+begin<sub>src</sub> bash
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
  mu init &#x2013;maildir=~/Mail &#x2013;my-address="$email"
  mu index
  #+end<sub>sr</sub>


<a id="org7aba110"></a>

## QuteBrowser


<a id="org84c6184"></a>

### install the dracula theme

    git clone https://github.com/dracula/qutebrowser-dracula-theme.git ~/.config/qutebrowser/dracula/
    echo ".config/qutebrowser/dracula/" >> .gitignore #dracula is a git repository

