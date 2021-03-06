#!/bin/sh

#=========================
# Install Homebrew
#=========================
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

#=========================
# Install Packages
#=========================
brew bundle

#==========================
# Ruby Settings from rbenv
#==========================
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi
/usr/local/bin/rbenv install 2.1.2
/usr/local/bin/rbenv global 2.1.2
/usr/local/bin/rbenv rehash

#==========================
# Ruby Settings from gem
#==========================
gem install bundler --no-ri --no-rdoc
gem install rails --no-ri --no-rdoc
gem install padrino --no-ri --no-rdoc
gem install chef --no-ri --no-rdoc
gem install knife-solo --no-ri --no-rdoc

#==========================
# Vagrant Plugin Settings
#==========================
vagrant plugin install sahara

#==========================
# MySql Settings
#==========================
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

#==========================
# Mac Settings
#==========================
# 通知センターをOFF
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
# Finderの音を消す
defaults write com.apple.finder FinderSounds -bool no
# iTunesの背景を変更
defaults write com.apple.iTunes high-contrast-mode-enable -bool true
#==========================
# Notification
#==========================
echo "=============================================="
echo "Finish Install Apps"
echo "Do the following"
echo "=============================================="
echo ""
echo "bash Settings"
echo "fix /etc/shells"
echo "chpass -s /usr/local/bin/bash"
echo ""
echo ""
echo "bash-completion Settings"
echo "if [ -f $(brew --prefix)/etc/bash_completion ]; then"
echo "  . $(brew --prefix)/etc/bash_completion"
echo "fi"
echo ""
echo "coreutils Settings"
echo "PATH=\"/usr/local/opt/coreutils/libexec/gnubin:$PATH\""
echo "MANPATH=\"/usr/local/opt/coreutils/libexec/gnuman:$MANPATH\""
echo ""
echo "MySQL Settings"
echo "ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents"
echo "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
echo "mysql.server start"
echo "mysqladmin -u root password \"your password\""
echo "mysqladmin -u root -h your hostname password \"your password\""
echo ""
echo "rbenv Settings"
echo "export RBENV_ROOT=/usr/local/var/rbenv"
echo "if which rbenv > /dev/null; then"
echo "  eval \"$(rbenv init -)\";"
echo "fi"
echo ""
