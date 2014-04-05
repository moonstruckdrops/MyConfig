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
/usr/local/bin/rbenv install 2.0.0-p247
/usr/local/bin/rbenv global 2.0.0-p247
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
