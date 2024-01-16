##############USER SPECIFIED################
#Aliases
alias ce='rm *~'
alias e=' emacs -nw '
alias glances='glances -1 --fs-free-space'
alias octave='octave --no-gui -q'
alias backup='~/scripts/backup.sh'
alias wgu='wg-quick up peer_terminator'
alias wgd='wg-quick down peer_terminator'
alias klayout='XDG_SESSION_TYPE=x11 klayout -e'

export VISUAL=emacs
export EDITOR=emacs

#export QT_QPA_PLATFORM=wayland

export TMPDIR=/tmp #useful for programs like qe

#################
#Path extensions#
#################
# gaussian 16
#export g16root=~/src/g16/
#export GAUSS_EXEDIR=$g16root:$g16root/bsd
#export GAUSS_SCRDIR=/home/$USER/scratch
#export GAUSS_ARCDIR=$g16root/arch
#. $g09root/g09/bsd/g09.profile

#adds qe binaries to path
#export QE_BIN=~/src/quantum_espresso-6.2.1/bin
#export PATH=$PATH:$(cat ~/.qe_binaries.txt)
#export ESPRESSO_TMPDIR=~/scratch

#add cmake to path
#export CMAKE_BIN=/opt/cmake-3.25.0-linux-x86_64/bin

# Add AmberTools22 to path
#export AMBER_BIN=/opt/amber22/bin

#allows executables in cwd and ~/bin to by run as env_var
export PATH=$PATH:/opt/:~/scripts/:./:~/.local/bin #:$QE_BIN:$g16root:$CMAKE_BIN:$AMBER_BIN

# remove duplicate path entries
export PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

# Creates a backup of the file passed as parameter with the date and time
function bak()
{
  cp $1 $1_`date +%H:%M:%S_%d-%m-%Y`
}

#counts things when to ls | wc -1 won't work
count() {
    count=0
    for i in $@ ; do
	((count++))
    done
    echo $count
}

# A better evince shortcut
ev() { (evince "$1" 1>/dev/null 2>/dev/null &) } 
complete -f -o default -X '!*.pdf' ev

# Gives a % breakdown of the top 10 bash commands used by user
hist_breakdown() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}

# Compress stuff
function compress_() {
   FILE=$1
   shift
   case $FILE in
      *.tar.bz2) tar cjf $FILE $*  ;;
      *.tar.gz)  tar czf $FILE $*  ;;
      *.tgz)     tar czf $FILE $*  ;;
      *.zip)     zip $FILE $*      ;;
      *.rar)     rar $FILE $*      ;;
      *)         echo "Filetype not recognized" ;;
   esac
}

# Automatically extract any compressed file, regardless of ext
function extract {
    if [ -z "$1" ]; then
	# display usage if no parameters given
	echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
	echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
	return 1
    else
	for n in $@
	do
	    if [ -f "$n" ] ; then
		case "${n%,}" in
		    *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
			tar xvf "$n"       ;;
		    *.lzma)      unlzma ./"$n"      ;;
		    *.bz2)       bunzip2 ./"$n"     ;;
		    *.rar)       unrar x -ad ./"$n" ;;
		    *.gz)        gunzip ./"$n"      ;;
		    *.zip)       unzip ./"$n"       ;;
		    *.z)         uncompress ./"$n"  ;;
		    *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
			7z x ./"$n"        ;;
		    *.xz)        unxz ./"$n"        ;;
		    *.exe)       cabextract ./"$n"  ;;
		    *)
			echo "extract: '$n' - unknown archive method"
			return 1
			;;
		esac
	    else
		echo "'$n' - file does not exist"
		return 1
	    fi
	done
    fi
}

# find the IP addresses that are currently online in your network
function localIps()
{
for i in {1..254}; do
	x=`ping -c1 -w1 192.168.1.$i | grep "%" | cut -d"," -f3 | cut -d"%" -f1 | tr '\n' ' ' | sed 's/ //g'`
	if [ "$x" == "0" ]; then
		echo "192.168.1.$i"
	fi
done
}

#display package command came from
function cmdpkg() { PACKAGE=$(dpkg -S $(which $1) | cut -d':' -f1); echo "[${PACKAGE}]"; dpkg -s "${PACKAGE}" ;}

## Script to randomly set desktop/gdm background from files in a directory(s) in GNOME3
#function randomwp()
#{
####### Directories Containing Pictures (to add more folders here, just "/path/to/your/folder")
#arr[0]="$HOME/pictures/"
##arr[1]="/usr/share/backgrounds"
## arr[2]=
## arr[3]=
## arr[4]=
## arr[5]=
## arr[6]=
## arr[7]=
## arr[8]=
## arr[9]=
## arr[10]=
####### How many picture folders are there? (currently = 2)
#rand=$[ $RANDOM % 1]
####### Command to select a random folder
#DIR=`echo ${arr[$rand]}`
####### Command to select a random file from directory
## The *.* should select only files (ideally, pictures, if that's all that's inside)
#PIC=$(ls $DIR/*.* | shuf -n1)
####### Command to set background Image
#gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
#}
#
#randomwp


#################DEFAULTS###################

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
