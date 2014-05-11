##############################
#
# BasePath
#
##############################
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

##############################
#
# Locale
#
##############################
export LANG=ja_JP.UTF-8
export LANG

##############################
#
# Get the aliases and functions
#
##############################
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

##############################
#
# export
#
##############################
# ls
if [ `echo "${OSTYPE}" |grep "linux*"` ];then
    eval `dircolors ~/.dir_colors`
    alias ls='ls --time-style="+%Y/%m/%d %H:%M:%S" --color=auto'
elif [ `/usr/local/bin/brew 'list' | grep 'coreutils'` ]&&[ -f ~/.dir_colors ];then
    # Homebrewインストール(GNU)
    # CustomColor
    # di=36;40:ln=1;;40:so=35;47:pi=0;46:ex=31;40:bd=35;47:cd=35;47:su=0;41:sg=0;46:tw=36;43:ow=36;45:
    eval `gdircolors ~/.dir_colors`
    alias ls='gls --time-style="+%Y/%m/%d %H:%M:%S" --color=auto'
else
    # Macデフォルト(BSD)
    # Mac's default color.
    # LSCOLORS=gxfxcxdxbxegedabagacad
    # LS_COLORS=di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:
    export LSCOLORS=gxGxfhagbxfhfhabaggdgf
    alias ls='ls -G'
fi

# Ruby
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi
#Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home
# Groovy
export GROOVY_HOME='/usr/local/Cellar/groovy/2.1.5/libexec'
# Android
export ANDROID_HOME=/usr/local/share/android-sdk
# export ANDROID_SOURCE=~/source/Android


# TOMCAT
export CATALINA_HOME='/usr/local/Cellar/tomcat/7.0.47/libexec'

# Golang
#export GOROOT=$HOME/go/src
#export GOOS=darwin
#export GOARCH=386
#export GOBIN=$HOME/go/bin
#export PATH=$GOBIN:$PATH
export GOPATH="/usr/local/Cellar/go/1.1.2/"
export PATH=$PATH:$GOPATH/bin

# Packer
export PACKER_LOG=1

# homebrew
if [ `echo "${OSTYPE}" |grep "darwin*"` ];then
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

##############################
#
# Completion
#
##############################
# Bash-completion
if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
elif [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
elif [ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]; then
    . $(brew --prefix)/etc/profile.d/bash_completion.sh
fi

# Git
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash  ]; then
    . /usr/local/etc/bash_completion.d/git-completion.bash
fi

# adb_completion for Android Source.
#if [ -f $ANDROID_SOURCE/sdk/bash_completion/adb.bash ]; then
#    . $ANDROID_SOURCE/sdk/bash_completion/adb.bash
#fi



##############################
#
# prompt
#
##############################
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh  ]; then
    . /usr/local/etc/bash_completion.d/git-prompt.sh
    export PS1='\u@\h:\w$(__git_ps1 " (%s)")$'
else
    export PS1="\u@\h:\w$"
fi

# histroyの日付フォーマット
HISTTIMEFORMAT='%Y/%m/%d %T : ';
export HISTTIMEFORMAT
# historyの数を増やす
export HISTSIZE=10000
# コマンドの履歴に残さない
export HISTIGNORE="fg*:bg*:history*:cd*:ls*:source*:ll*"
# 空白を履歴に保存せず、重複履歴を保存しない
export HISTCONTROL=ignoreboth

# Java
PATH=${JAVA_HOME}/bin:$PATH
# Android
PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/platforms
#Android Source
#PATH=$PATH:${ANDROID_SOURCE}
#TOMCAT
PATH=$PATH:${CATALINA_HOME}


##############################
#
# alias
#
##############################
alias emacs="/usr/local/bin/emacs"
alias ec="/usr/local/bin/emacsclient"
alias javac='javac -J-Dfile.encoding=UTF8'
alias eclipse="/Applications/eclipse/Eclipse.app/Contents/MacOS/eclipse"
alias ll='ls -atlh'


#alias mvn='/usr/local/Cellar/maven2/2.2.1/bin/mvn'
alias startup2Tomcat='/usr/local/Cellar/tomcat/7.0.47/libexec/bin/startup.sh'
alias shutdown2Tomcat='/usr/local/Cellar/tomcat/7.0.47/libexec/bin/shutdown.sh'



#git
#alias git="/usr/local/Cellar/git/1.7.12/bin/git"
#alias git-cvsserver="/usr/local/Cellar/git/1.7.12/bin/git-cvsserver"
#alias git-shell="/usr/local/Cellar/git/1.7.12/bin/git-shell"
#alias git-upload-pack="/usr/local/Cellar/git/1.7.12/bin/git-upload-pack"
#alias git-credential-osxkeychain="git-credential-osxkeychain"
#alias git-receive-pack="/usr/local/Cellar/git/1.7.12/bin/git-receive-pack"
#alias git-upload-archive="/usr/local/Cellar/git/1.7.12/bin/git-upload-archive"
#alias gitk="/usr/local/Cellar/git/1.7.12/bin/gitk"


# SVN
#alias svn='/opt/local/bin/svn'

#repo
#export PATH=$ANDROID_HOME/repo:$PATH
