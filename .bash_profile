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
# export
#
##############################
# ls
export LSCOLORS=gxfxcxdxbxegedabagacad
# Ruby
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi
#Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home
# Groovy
export GROOVY_HOME='/usr/local/Cellar/groovy/2.1.5/libexec'
# Android
export ANDROID_HOME=/usr/local/share/android-sdk
# export ANDROID_SOURCE=~/source/Android
# TOMCAT
export CATALINA_HOME='/usr/local/Cellar/tomcat/7.0.29/libexec'

# Golang
#export GOROOT=$HOME/go/src
#export GOOS=darwin
#export GOARCH=386
#export GOBIN=$HOME/go/bin
#export PATH=$GOBIN:$PATH


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

##############################
#
# CustomPath
#
##############################
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
alias ls="ls -G"
alias ll="ls -atl"


#alias mvn='/usr/local/Cellar/maven2/2.2.1/bin/mvn'
#alias startup2Tomcat='/usr/local/Cellar/tomcat/7.0.29/libexec/bin/startup.sh'
#alias shutdown2Tomcat='/usr/local/Cellar/tomcat/7.0.29/libexec/bin/shutdown.sh'



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

