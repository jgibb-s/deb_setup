#! /bin/bash

#TODO: organize packages to allow user to choose (ie space to select from list like in pro installers)

echo -e "run \n\nsudo sed -i.bak 's/bullseye[^ ]* main$/& contrib non-free/g' /etc/apt/sources.list \n\nto add non-free firmware (ie firmware-realtek)"

read -p "Do you wish to update/upgrade apt? " ans1
if echo "$ans1" | grep -iq "^y" ; then
    echo "updating"
    # Keep Debian up to date
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt-get -y autoremove
else
    echo "apt already updated"
fi

#install packages
cat package.list | awk '{ print $1 }'
echo
read -p "install the listed packages? " ans2
if echo "$ans2" | grep -iq "^y" ; then
    echo "installing packages"
    while read -r line ; do
	sudo apt-get -y install $(echo $line | awk '{ print $1 }')
	echo "$(echo $line | awk '{ print $1 }') installed"
    done < "package.list"
else
    echo "skipping pacakges"
fi

echo -e "\n"

#cloning git repos
cat git.list | awk '{ print $1 }'
echo "Under development"
#read -p "clone the following? " ans3
#
#GIT='/home/josh/git'
#
#git_stty=$(stty -g)
#stty raw -echo ; ans3=$(head -c 1) ; stty $git_stty # Careful playing with stty
#if echo "$ans3" | grep -iq "^y" ; then
#    echo "cloning repos"
#    while read -r line ; do
#	name=$(echo $line | cut -d'/' -f5 | awk '{ print $1 }')
#	echo "name ${name%.git}"
#	if [ ! -d '${GIT}/${name}' ] ; then
#	    cd ${GIT}
#	    echo "cloning  $(echo $line | awk '{ print $1 }')"
#	    git clone $(echo $line | awk '{ print $1 }')
#	elif [ -d '${GIT}/${name%.git}' ] ; then
#	     echo "repo already cloned, updating now"
#	     echo "pulling  $(echo $line | awk '{ print $1 }')"
#	     git pull $(echo $line | awk '{ print $1 }')
#	fi
#    done < "git.list"
#else
#    echo "skipping git repos"
#fi
#



