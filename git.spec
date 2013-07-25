%define perl_vendorlib %(eval "`%{__perl} -V:installvendorlib`"; echo $installvendorlib)
%define perl_vendorarch %(eval "`%{__perl} -V:installvendorarch`"; echo $installvendorarch)

%define desktop_vendor kurobara

Summary: Git core and tools
Name: git
Version: 1.8.1.1
Release: %{?dist}.3
License: GPL
Group: Development/Tools
URL: http://git-scm.com/

Packager: kurobara
Vendor: kurobara

Source0: https://git-core.googlecode.com/files/git-%{version}.tar.gz
Source1: gitweb.conf.in
BuildRoot: %{_tmppath}/%{name}-%{version}-root

BuildRequires: asciidoc > 6.0.3
BuildRequires: curl-devel >= 7.9
BuildRequires: desktop-file-utils
BuildRequires: expat-devel
BuildRequires: gettext
BuildRequires: emacs
BuildRequires: openssl-devel
BuildRequires: perl(ExtUtils::MakeMaker)
BuildRequires: xmlto
BuildRequires: zlib-devel >= 1.2
Requires: less
Requires: openssh-clients
Requires: perl-Git = %{version}-%{release}
Requires: rsync
Requires: zlib >= 1.2

Obsoletes: git-core <= %{version}-%{release}
Provides: git-core = %{version}-%{release}

%description
GIT comes in two layers. The bottom layer is merely an extremely fast
and flexible filesystem-based database designed to store directory trees
with regard to their history. The top layer is a SCM-like tool which
enables human beings to work with the database in a manner to a degree
similar to other SCM tools (like CVS, BitKeeper or Monotone).

%package all
Summary: Meta-package to pull in all git tools
Group: Development/Tools
Requires: emacs-git = %{version}-%{release}
Requires: git = %{version}-%{release}
Requires: git-arch = %{version}-%{release}
Requires: git-cvs = %{version}-%{release}
Requires: git-email = %{version}-%{release}
Requires: git-gui = %{version}-%{release}
Requires: git-svn = %{version}-%{release}
Requires: gitk = %{version}-%{release}
Requires: perl-Git = %{version}-%{release}
Obsoletes: git <= 1.5.4.3

%description all
Git is a fast, scalable, distributed revision control system with an
unusually rich command set that provides both high-level operations
and full access to internals.

This is a dummy package which brings in all subpackages.

%package arch
Summary: Git tools for importing Arch repositories
Group: Development/Tools
Requires: %{name} = %{version}-%{release}

%description arch
Git tools for importing Arch repositories.

%package cvs
Summary: Git tools for importing CVS repositories
Group: Development/Tools
Requires: cvs
Requires: cvsps
Requires: %{name} = %{version}-%{release}

%description cvs
Git tools for importing CVS repositories.

%package daemon
Summary: Git protocol daemon
Group: Development/Tools
Requires: %{name} = %{version}-%{release}
Requires: xinetd

%description daemon
The git daemon for supporting git:// access to git repositories

%package email
Summary: Git tools for sending email
Group: Development/Tools
Requires: %{name} = %{version}-%{release}
Requires: perl-Git = %{version}
Requires: perl(Authen::SASL::Perl)
Requires: perl(Email::Valid)
Requires: perl(Mail::Address)
Requires: perl(Net::Domain)
Requires: perl(Net::SMTP::SSL)
Requires: perl(Sys::Hostname)

%description email
Git tools for sending email.

%package gui
Summary: Graphical frontend to git
Group: Development/Tools
Requires: %{name} = %{version}-%{release}
Requires: tk >= 8.4
Requires: gitk = %{version}-%{release}

%description gui
Graphical frontend to git.

%package svn
Summary: Git tools for importing Subversion repositories
Group: Development/Tools
Requires: %{name} = %{version}-%{release}
Requires: perl(Error)
Requires: perl(Term::ReadKey)
Requires: subversion

%description svn
Git tools for importing Subversion repositories.

%package -n emacs-git
Summary: Git version control system support for Emacs
Group: Applications/Editors
Requires: %{name} = %{version}-%{release}
Requires: emacs-common

%description -n emacs-git
%{summary}.

%package -n gitk
Summary: Git revision tree visualiser
Group: Development/Tools
Requires: %{name} = %{version}-%{release}
Requires: tk >= 8.4

%description -n gitk
Git revision tree visualiser.

%package -n gitweb
Summary: Simple web interface to git repositories
Group: Development/Tools
Requires: %{name} = %{version}-%{release}

%description -n gitweb
Simple web interface to track changes in git repositories

%package -n perl-Git
Summary: Perl module that implements Git bindings
Group: Applications/CPAN
### 以下の理由でコメントアウト
### 動作に必要という点ではgitに依存する
### 設定した場合にgitそのものがインストールできなくなる
#Requires: %{name} = %{version}-%{release}

%description -n perl-Git
Git is a Perl module that implements Git bindings.

%prep
%setup

%{__cat} <<EOF >config.mak
V = 1
CFLAGS = %{optflags}
BLK_SHA1 = 1
NEEDS_CRYPTO_WITH_SSL = 1
NO_PYTHON = 1
ETC_GITCONFIG = %{_sysconfdir}/gitconfig
DESTDIR = %{buildroot}
INSTALL = install -p
GITWEB_PROJECTROOT = %{_localstatedir}/lib/git
htmldir = %{_docdir}/%{name}-%{version}
prefix = %{_prefix}
INSTALLDIRS = vendor
mandir = %{_mandir}
WITH_OWN_SUBPROCESS_PY = YesPlease
ASCIIDOC_EXTRA = --unsafe
EOF

### gitdaemonの設定
### gitdaemon用のxファイルを生成
%{__cat} <<EOF >git.xinetd
# default: off
# description: The git daemon allows git repositories to be exported using \
#       the git:// protocol.

service git
{
        disable         = yes

        # git is in /etc/services only on RHEL5+
        #type            = UNLISTED
        #port            = 9418

        socket_type     = stream
        wait            = no
        user            = nobody
        server          = %{_libexecdir}/git-core/git-daemon
        server_args     = --base-path=%{_localstatedir}/lib/git --export-all --user-path=public_git --syslog --inetd --verbose
        log_on_failure  += USERID
        # xinetd does not enable IPv6 by default
        # flags           = IPv6
}
EOF

### gitguiの設定
### gitgui.desktopの生成
%{__cat} <<EOF >git-gui.desktop
[Desktop Entry]
Name=Git GUI
GenericName=Git GUI
Comment=A graphical interface to Git
Exec=git gui
Icon=%{_datadir}/git-gui/lib/git-gui.ico
Terminal=false
Type=Application
Categories=Development;
EOF

### gitwebの設定
### gitweb.httpdの生成
%{__cat} <<EOF >gitweb/gitweb.httpd
Alias /git %{_datadir}/gitweb

<Directory %{_datadir}/gitweb>
    Options +ExecCGI
    AddHandler cgi-script .cgi
    DirectoryIndex gitweb.cgi
</Directory>
EOF
### gitweb.confの生成
%{__sed} -e "s|@PROJECTROOT@|%{_localstatedir}/lib/git|g" %{SOURCE1} >gitweb.conf

### RPMインストール設定
### インストール時に設定される不要な依存を削除する
cat << \EOF > %{name}-req
#!/bin/sh
%{__perl_requires} $* |\
sed -e '/perl(packed-refs)/d'
EOF

%global __perl_requires %{_builddir}/%{name}-%{version}/%{name}-req
chmod +x %{__perl_requires}


%build
%{__make} %{?_smp_mflags} all

# bah, DocBook validation errors
%{__perl} -pi -e 's|^XMLTO_EXTRA =\s*$|XMLTO_EXTRA = --skip-validation \n|;' Documentation/Makefile

%{__make} %{?_smp_mflags} doc

## Perl preparation
cd perl
%{__perl} Makefile.PL DESTDIR="%{buildroot}" PREFIX="%{_prefix}"  INSTALLDIRS=%{perl_vendorlib}
%{__make} %{?_smp_mflags}
cd -

# Remove shebang from bash-completion script
sed -i '/^#!bash/,+1 d' contrib/completion/git-completion.bash

%install
### 初期化の実施
%{__rm} -rf %{buildroot}
### git installation
%{__make} install install-doc DESTDIR="%{buildroot}"
%{__make} -C contrib/emacs install emacsdir="%{buildroot}%{_datadir}/emacs/site-lisp"
for elc in %{buildroot}%{_datadir}/emacs/site-lisp/*.elc; do
    %{__install} -p -m0644 contrib/emacs/$(basename $elc .elc).el %{buildroot}%{_datadir}/emacs/site-lisp/
done
#%{__install} -Dp -m0644 %{SOURCE1} %{buildroot}%{_datadir}/emacs/site-lisp/site-start.d/git-init.el

### perl-Git installation
### perlモジュールのインストールでエラーが出ていたので個別にインストールする
%{__install} -p -m0644 perl/blib/lib/Git.pm %{buildroot}/usr/share/perl5/Git.pm
%{__install} -p -m0644 perl/blib/lib/Git/I18N.pm %{buildroot}/usr/share/perl5/Git/I18N.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Editor.pm %{buildroot}/usr/share/perl5/Git/SVN/Editor.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Fetcher.pm %{buildroot}/usr/share/perl5/Git/SVN/Fetcher.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Memoize/YAML.pm %{buildroot}/usr/share/perl5/Git/SVN/Memoize/YAML.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Prompt.pm %{buildroot}/usr/share/perl5/Git/SVN/Prompt.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Ra.pm %{buildroot}/usr/share/perl5/Git/SVN/Ra.pm
%{__install} -p -m0644 perl/blib/lib/Git/IndexInfo.pm %{buildroot}/usr/share/perl5/Git/IndexInfo.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN.pm %{buildroot}/usr/share/perl5/Git/SVN.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/GlobSpec.pm %{buildroot}/usr/share/perl5/Git/SVN/GlobSpec.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Log.pm %{buildroot}/usr/share/perl5/Git/SVN/Log.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Migration.pm %{buildroot}/usr/share/perl5/Git/SVN/Migration.pm
%{__install} -p -m0644 perl/blib/lib/Git/SVN/Utils.pm %{buildroot}/usr/share/perl5/Git/SVN/Utils.pm

### gitweb installation
%{__install} -d -m0755 %{buildroot}%{_localstatedir}/www/git/static/
%{__install} -p -m0755 gitweb/gitweb.cgi %{buildroot}%{_localstatedir}/www/git/
%{__install} -p -m0755 gitweb/gitweb.perl %{buildroot}%{_localstatedir}/www/git/
%{__cp} -av gitweb/static/* %{buildroot}%{_localstatedir}/www/git/static/
%{__install} -Dp -m0644 gitweb/gitweb.httpd %{buildroot}%{_sysconfdir}/httpd/conf.d/git.conf
%{__install} -Dp -m0644 gitweb.conf %{buildroot}%{_sysconfdir}/gitweb.conf

### git-daemon installation
%{__install} -d -m0755 %{buildroot}%{_localstatedir}/lib/git/
%{__install} -d -m0755 %{buildroot}%{_sysconfdir}/xinetd.d/
%{__install} -Dp -m0644 git.xinetd %{buildroot}%{_sysconfdir}/xinetd.d/git

### contrib installation
%{__install} -Dp -m0644 contrib/completion/git-completion.bash %{buildroot}%{_sysconfdir}/bash_completion.d/git

# Move contrib/hooks out of %%docdir and make them executable
%{__install} -d -m0755 %{buildroot}%{_datadir}/git-core/contrib/
%{__mv} -v contrib/hooks %{buildroot}%{_datadir}/git-core/contrib
chmod +x %{buildroot}%{_datadir}/git-core/contrib/hooks/*
pushd contrib > /dev/null
ln -s ../../../git-core/contrib/hooks
popd > /dev/null

desktop-file-install \
    --vendor %{desktop_vendor} \
    --dir=%{buildroot}%{_datadir}/applications \
    git-gui.desktop

### Quiet some rpmlint complaints
chmod -R g-w %{buildroot}
find %{buildroot} -name git-mergetool--lib | xargs chmod a-x
rm -f {Documentation/technical,contrib/emacs}/.gitignore
chmod a-x Documentation/technical/api-index.sh
find contrib -type f | xargs chmod -x

### Clean up buildroot
find %{buildroot}%{_bindir} -type f -exec %{__perl} -pi -e 's|^%{buildroot}||' {} \;
%{__rm} -rf %{buildroot}%{perl_archlib} %{buildroot}%{perl_vendorarch} %{buildroot}%{_datadir}/locale/*

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-, root, root, 0755)
%doc COPYING Documentation/*.txt README
%doc %{_mandir}/man1/*.1*
%doc %{_mandir}/man5/*.5*
%doc %{_mandir}/man7/*.7*
%config %{_sysconfdir}/bash_completion.d/
%{_datadir}/emacs/site-lisp/git*
%{_bindir}/git
%{_bindir}/git-*
%{_datadir}/git-core/
%{_libexecdir}/git-core/
%exclude %{_libexecdir}/git-core/git-citool
%exclude %{_libexecdir}/git-core/git-cvsexportcommit
%exclude %{_libexecdir}/git-core/git-cvsimport
%exclude %{_libexecdir}/git-core/git-cvsserver
%exclude %{_libexecdir}/git-core/git-daemon
%exclude %{_libexecdir}/git-core/git-gui
%exclude %{_libexecdir}/git-core/git-gui--askpass
%exclude %{_libexecdir}/git-core/git-send-email
%exclude %{_libexecdir}/git-core/git-svn

%files all
%defattr(-, root, root, 0755)

%files arch
%defattr(-, root, root, 0755)
%{_libexecdir}/git-core/git-archimport

%files cvs
%defattr(-, root, root, 0755)
%{_bindir}/git-cvsserver
%{_libexecdir}/git-core/git-cvsexportcommit
%{_libexecdir}/git-core/git-cvsimport
%{_libexecdir}/git-core/git-cvsserver

%files daemon
%defattr(-, root, root, 0755)
%doc Documentation/*daemon*.txt
%config(noreplace)%{_sysconfdir}/xinetd.d/git
%{_libexecdir}/git-core/git-daemon
%{_localstatedir}/lib/git/

%files email
%defattr(-, root, root, 0755)
%{_libexecdir}/git-core/git-send-email

%files gui
%defattr(-, root, root, 0755)
%{_datadir}/applications/%{desktop_vendor}-git-gui.desktop
%{_datadir}/git-gui/
%{_libexecdir}/git-core/git-citool
%{_libexecdir}/git-core/git-gui
%{_libexecdir}/git-core/git-gui--askpass

%files svn
%defattr(-, root, root, 0755)
%{_libexecdir}/git-core/git-svn

%files -n gitk
%defattr(-,root,root)
%doc Documentation/*gitk*.txt
%{_bindir}/gitk
%{_datadir}/gitk/

%files -n gitweb
%defattr(-, root, root, 0755)
%doc gitweb/GITWEB-BUILD-OPTIONS gitweb/INSTALL gitweb/README
%config(noreplace) %{_sysconfdir}/gitweb.conf
%config(noreplace) %{_sysconfdir}/httpd/conf.d/git.conf
%{_datadir}/gitweb/
%{_localstatedir}/www/git/*.cgi
%{_localstatedir}/www/git/*.perl
%{_localstatedir}/www/git/static/*.css
%{_localstatedir}/www/git/static/*.png
%{_localstatedir}/www/git/static/*.js
%{_localstatedir}/www/git/static/js/**

%files -n perl-Git
%defattr(-, root, root, 0755)
%doc %{_mandir}/man3/Git.3pm*
%doc %{_mandir}/man3/Git::I18N.3pm*
%doc %{_mandir}/man3/Git::SVN::Editor.3pm.gz
%doc %{_mandir}/man3/Git::SVN::Fetcher.3pm.gz
%doc %{_mandir}/man3/Git::SVN::Memoize::YAML.3pm.gz
%doc %{_mandir}/man3/Git::SVN::Prompt.3pm.gz
%doc %{_mandir}/man3/Git::SVN::Ra.3pm.gz
# perlモジュールのインストールでエラーが出るので個別にパッケージするファイルを指定
/usr/share/perl5/Git.pm
/usr/share/perl5/Git/I18N.pm
/usr/share/perl5/Git/SVN/Editor.pm
/usr/share/perl5/Git/SVN/Fetcher.pm
/usr/share/perl5/Git/SVN/Memoize/YAML.pm
/usr/share/perl5/Git/SVN/Prompt.pm
/usr/share/perl5/Git/SVN/Ra.pm
# git-1.8.1.1で追加になったモジュール
%doc %{_mandir}/man3/Git::SVN::Utils.3pm.gz
/usr/share/perl5/Git/IndexInfo.pm
/usr/share/perl5/Git/SVN.pm
/usr/share/perl5/Git/SVN/GlobSpec.pm
/usr/share/perl5/Git/SVN/Log.pm
/usr/share/perl5/Git/SVN/Migration.pm
/usr/share/perl5/Git/SVN/Utils.pm
