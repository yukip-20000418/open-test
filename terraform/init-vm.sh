#!/bin/bash

export TZ=Asia/Tokyo

logname="startup-script-log.txt"
username="ubuntu"

echo "$(date) [ START ] metadata_startup_script" >> $logname 2>&1

cat <<'END' | sed 's/^ \{4\}//' > /home/$username/init.sh
    #!/bin/bash
    set -x
    echo "\$nrconf{restart} = 'a';" \
    | sudo tee /etc/needrestart/conf.d/100.add-yukip.conf

    sudo snap remove google-cloud-cli
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y git
    sudo apt install -y vim

    sudo snap install flutter --classic
    flutter --version

    flutter config --no-enable-android
    flutter config --no-enable-ios
    flutter config --no-enable-linux-desktop
    flutter config --no-enable-macos-desktop
    flutter config --no-enable-windows-desktop
    flutter config --no-enable-custom-devices

    git config --global user.name "yukip"
    git config --global user.email "yukip@chottodake.dev"
END

chmod 744 /home/$username/init.sh >> $logname 2>&1
chown $username:$username /home/$username/init.sh >> $logname 2>&1

if ! test -e /home/$username/yukip.bashrc; then
    echo "source ~/yukip.bashrc" >> /home/$username/.bashrc

    cat <<'....END' | sed 's/^ \{8\}//' > /home/$username/yukip.bashrc
        # env
        export TZ=Asia/Tokyo

        # history
        HISTSIZE=200000
        HISTFILESIZE=20000
        alias hist='history | grep -v "hist " | grep --color=never'

        # etc
        unalias l
        unalias grep
        alias la='ls -al'
        alias ll='ls -l'

        # git
        alias gitlog='git fetch;git log --oneline --graph --all origin/master'
        alias gitcommit='git add .;git commit -m '
        alias gitpush='git push;git push --tags'
        alias gitdiff='git fetch;git diff --name-status master origin/master'

        # prompt
        PS1='\n\[\e[1;33m\][$(date +%Y/%m/%d) \t \w]\n\$\[\e[0m\] '
....END

    chmod 664 /home/$username/yukip.bashrc >> $logname 2>&1
    chown $username:$username /home/$username/yukip.bashrc >> $logname 2>&1
fi

echo "$(date) [ FINISH ] metadata_startup_script" >> $logname 2>&1
