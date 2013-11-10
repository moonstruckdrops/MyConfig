#!/bin/sh

#=========================
# Check Dependency App
#=========================
if [ ! `/usr/bin/which 'Xquartz'` ] ;then
    echo "Please install Xquartz App"
    echo "From: http://xquartz.macosforge.org/"
    exit 1
fi

#=========================
# Install Homebrew
#=========================
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

#=========================
# Homebrew's setting
#=========================
brew tap homebrew/versions
brew tap homebrew/binary

#==========================
# Instal Apps with Homebrew
#==========================
# Install Git
brew install git

# Install Bash
brew install bash
brew install bash-completion

# Install coreutils
brew install coreutils

# Install Emacs
brew install emacs --cocoa --keep-ctags --srgb --with-gnutls --with-x

# Install Ruby 
brew install rbenv
brew install ruby-build --with-openssl

# Install Golang
brew install go --cross-compile-all

# Install Database
brew install mysql --enable-memcached

# Install JavaDevelopment Tools.
brew install groovy --invokedynamic
brew install groovyserv
brew Install gradle
brew install ivy
brew install maven2
brew install tomcat

# Install packer
brew install packer

# Install wireshark
brew install wireshark --with-x

# Install jq
brew install jq

#==========================
# link for installed app
#==========================
brew linkapps

#==========================
# Ruby Settings from rbenv
#==========================
rbenv install 2.0.0-p247
rbenv rehash
rbenv global 2.0.0-p247
rbenv rehash

#==========================
# MySql Settings
#==========================
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

#==========================
# Notification
#==========================
echo "=============================================="
echo "Finish Install Apps"
echo "Do the following"
echo "=============================================="
echo ""
echo "bash-completion Settings"
echo "if [ -f $(brew --prefix)/etc/bash_completion ]; then"
echo "  . $(brew --prefix)/etc/bash_completion"
echo "fi"
echo ""
echo "MySQL Settings"
echo "mysql.server start"
echo "mysqladmin -u root password \"your password\""
echo ""
echo "rbenv Settings"
echo "export RBENV_ROOT=/usr/local/var/rbenv"
echo " if which rbenv > /dev/null; then eval \"$(rbenv init -)\"; fi"
