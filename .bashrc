##******************************************************************************
# Colors:
black='\e[0;30m'
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
blue='\e[0;34m'
purple='\e[0;35m'
cyan='\e[0;36m'
white='\e[0;37m'
lightblack='\e[1;30m'
lightred='\e[1;31m'
lightgreen='\e[1;32m'
lightyellow='\e[1;33m'
lightblue='\e[1;34m'
lightpurple='\e[1;35m'
lightcyan='\e[1;36m'
lightwhite='\e[1;37m'
darkred='\e[2;31m'
darkgreen='\e[2;32m'
darkyellow='\e[2;33m'
darkblue='\e[2;34m'
darkpurple='\e[2;35m'
darkcyan='\e[2;36m'
darkwhite='\e[2;37m'
nc='\e[0m'


##******************************************************************************
# If not running interactively, don't do anything
[ -z "$PS1" ] && return


##******************************************************************************
# Don't put duplicate lines in the history. See man bash for more options
HISTCONTROL=erasedups
# append to the history file, don't overwrite it
shopt -s histappend
# see man bash
HISTSIZE=50000
HISTFILESIZE=500000


##******************************************************************************
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


##******************************************************************************
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


##******************************************************************************
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"


##******************************************************************************
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

FANCY="\342\231\245"   # unicode heart (ALT code)

if [ "$color_prompt" = yes ]; then
    PS1="\[$lightyellow\]\h: \[$red\]\w \[$lightyellow\]$FANCY \[$nc\] "
else
    PS1="\h: \w \$ "
fi
unset color_prompt force_color_prompt


##******************************************************************************
# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
  *)
    ;;
esac


##******************************************************************************
# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi


##******************************************************************************
# Welcome message:
clear
echo -ne "$lightgreen"
figlet "Welcome, " $USER;
echo -ne "$lightyellow"
echo -ne "Today is "; date
echo -ne "Uptime: "; uptime | grep -o --color=no '[0-9:]*[ min]*[ days]*,.*'
top -b -n 1 -d 0 | grep --color=no "Tasks: "
echo -ne "$nc"
echo
w | grep -v --color=no "[0-9]*:[0-9]*:[0-9]*"
echo
df -h -x tmpfs -x udev # disk usage, minus def and swap


##******************************************************************************
# Git:
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(lightyellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit" 


##******************************************************************************
# Handy stuff:
alias path='echo -e ${PATH//:/\\n}'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ls='ls -l --color'
alias la='ls -la --color'
alias lsd='ls -l | grep "^d"' #list only directories
alias rm='mv -t ~/.local/share/Trash/files'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p -v'
alias df='df -h'
alias du='du -h -c --max-depth=1'
alias diff='colordiff'
alias reload='source ~/.bashrc'
alias top-commands='echo -e " Count:   Command:"; history | grep -o "  [a-z.:/-\"|_].*" | sort | uniq -c | sort -rn | head -10'
alias top-files='du -a /var | sort -n -r | head -n 10'


##******************************************************************************
# Sudo fixes
alias sudo='sudo env PATH=$PATH'
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias updatedb='sudo updatedb'


##******************************************************************************
# Easy extract
# Call with "extract filename"
extract()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       rar x $1       ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "Error: Don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

##******************************************************************************
# up <N>      goes "up" N directory
# down <N>    goes "down" N directories in the last directory tree you were
function up()
{
  LIMIT=$1
  if [[ "$LIMIT" == '' ]]; then LIMIT=1; fi;
  P=$PWD
  for ((i=1; i <= LIMIT; i++))
  do
      P=$P/..
  done
  cd $P
  export MPWD=$P
}

function down()
{
  L=$1
  if [[ "$L" == '' ]]; then L=1; fi;  
  P=$MPWD
  for ((i=1; i <= (L); i++))
  do
      P=${P%/..}
  done
  cd $P
  export MPWD=$P
}


##******************************************************************************
# Get current host related info
function ii() 
{
  echo -e "${cyan}Machine info: ${nc}"
  echo -e $HOSTNAME
  uname -a
  echo -e "${cyan}Machine stats:${nc} " ; uptime | grep -o --color=no "[0-9].*"
  echo -e "${cyan}Users logged on:${nc} " ; w -h
  echo -e "${cyan}Current date:${nc} " ; date
  echo -e "${cyan}Memory stats:${nc} " ; free
  echo -e "${cyan}Network: ${nc}" ; myip
}


##******************************************************************************
# Get IP infos
myip ()
{
  echo -ne "Global IP: ";  lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | grep "Current IP Address" | cut -d":" -f2 | cut -d" " -f2

  echo -ne "Lokal IP : ";  ifconfig eth0 | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*.* Bcast" | grep -o --color=no "[0-9.]*"
  echo -ne "BCast    : ";  ifconfig eth0 | grep -o "Bcast:[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*.* " | grep -o --color=no "[0-9.]*"
  echo -ne "Mask     : ";  ifconfig eth0 | grep -o "Mask:[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*.*" | grep -o --color=no "[0-9.]*"
}


##******************************************************************************
# Encryption/Decryption
# call with "encrypt filename" or "decrypt filename"
encrypt ()
{
  gpg -ac --no-options "$1"
}

decrypt ()
{
  gpg --no-options "$1"
}


##******************************************************************************
# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
mkzip() { zip -r "${1%%/}.zip" "${1%%/}"; }


##******************************************************************************
# Test if a file should be opened normally, or as root with editor and
# alternative editor. Change paths if you want another editor
function argc () 
{
  count=0;
  for arg in "$@"; do
    if [[ ! "$arg" =~ '-' ]]; then count=$(($count+1)); fi;
  done;
  echo $count;
}

function gedit () 
{ 
  if [[ `argc "$@"` > 1 ]]; then /usr/bin/gedit $@;
  elif [ $1 = '' ]; then /usr/bin/vim;
  elif [ ! -f $1 ] || [ -w $1 ]; then /usr/bin/gedit $@;
  else
    echo -n "File is readonly. Edit as root? (Y/n): "
    read -n 1 yn; echo;
    if [ "$yn" = 'n' ] || [ "$yn" = 'N' ];
      then /usr/bin/gedit $*;
    elif [ "$yn" = 'y' ] || [ "$yn" = 'Y' ] || [ "$yn" = 'j' ] || [ "$yn" = 'J' ]
      then sudo /usr/bin/gedit $*;
    fi
  fi
}

