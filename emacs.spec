Summary: GNU Emacs text editor
Name: emacs
Epoch: 1
Version: 24.2
Release: 21%{?dist}.3
License: GPLv3+
URL: http://www.gnu.org/software/emacs/
Group: Applications/Editors
Source0: ftp://ftp.gnu.org/gnu/emacs/emacs-%{version}.tar.bz2
Source1: emacs.desktop
#Source3: dotemacs.el
#Source4: site-start.el
#Source18: default.el


Buildroot: /usr/local/share/%{name}-%{version}-root
BuildRequires: atk-devel, cairo-devel, desktop-file-utils, freetype-devel, fontconfig-devel, dbus-devel, giflib-devel, glibc-devel, gtk2-devel, libpng-devel
BuildRequires: libjpeg-devel, libtiff-devel, libX11-devel, libXau-devel, libXdmcp-devel, libXrender-devel, libXt-devel
BuildRequires: libXpm-devel, ncurses-devel, xorg-x11-proto-devel, zlib-devel
BuildRequires: autoconf, automake, bzip2, cairo, texinfo
%ifarch %{ix86}
BuildRequires: setarch
%endif
Requires: emacs-common = %{epoch}:%{version}-%{release}


Requires: librsvg2
# Desktop integration
BuildRequires: desktop-file-utils
Requires:      desktop-file-utils
Conflicts: gettext < 0.10.40
Provides: emacs(bin)
Requires: m17n-db-datafiles

# C and build patches

# Lisp and doc patches

%define paranoid 1
%define expurgate 1

%define site_lisp %{_datadir}/emacs/site-lisp
%define site_start_d %{site_lisp}/site-start.d
%define bytecompargs -batch --no-init-file --no-site-file -f batch-byte-compile
%define pkgconfig %{_datadir}/pkgconfig

%description
Emacs is a powerful, customizable, self-documenting, modeless text
editor. Emacs contains special code editing features, a scripting
language (elisp), and the capability to read mail, news, and more
without leaving the editor.

This package provides an emacs binary with support for X windows.


%package common
Summary: Emacs common files
Group: Applications/Editors
Requires(preun): %{_sbindir}/alternatives, /sbin/install-info, dev
Requires(posttrans): %{_sbindir}/alternatives
Requires(post): /sbin/install-info, dev
Obsoletes: emacs-leim

%description common
Emacs is a powerful, customizable, self-documenting, modeless text
editor. Emacs contains special code editing features, a scripting
language (elisp), and the capability to read mail, news, and more
without leaving the editor.

This package contains all the common files needed by emacs or emacs-nox.

%package el
Summary: Emacs Lisp source files included with Emacs.
Group: Applications/Editors

%description el
Emacs-el contains the emacs-elisp sources for many of the elisp
programs included with the main Emacs text editor package.

You need to install emacs-el only if you intend to modify any of the
Emacs packages or see some elisp examples.

%define emacs_libexecdir %{_libexecdir}/emacs/%{version}/%{_host}

%prep
%setup -q

# we prefer our emacs.desktop file
cp %SOURCE1 etc/emacs.desktop

grep -v "tetris.elc" lisp/Makefile.in > lisp/Makefile.in.new \
   && mv lisp/Makefile.in.new lisp/Makefile.in

# avoid trademark issues
%if %{paranoid}
rm -f lisp/play/tetris.el lisp/play/tetris.elc
%endif

%if %{expurgate}
rm -f etc/sex.6 etc/condom.1 etc/celibacy.1 etc/COOKIES etc/future-bug etc/JOKES
%endif

%ifarch %{ix86}
%define setarch setarch %{_arch} -R
%else
%define setarch %{nil}
%endif

%build
export CFLAGS="-DMAIL_USE_LOCKF $RPM_OPT_FLAGS"

#we patch configure.in so we have to do this
%configure --with-dbus --with-gif --with-jpeg --with-png --with-rsvg \
   --with-tiff --with-xft --with-xpm --with-x-toolkit=gtk

%__make bootstrap
%{setarch} %__make %{?_smp_mflags}

# remove versioned file so that we end up with .1 suffix and only one DOC file
rm src/emacs-%{version}.*

%__make %{?_smp_mflags} -C lisp updates

# Create pkgconfig file
cat > emacs.pc << EOF
sitepkglispdir=%{site_lisp}
sitestartdir=%{site_start_d}

Name: emacs
Description: GNU Emacs text editor
Version: %{epoch}:%{version}
EOF

# Create macros.emacs RPM macro file
cat > macros.emacs << EOF
%%_emacs_version %{version}
%%_emacs_ev %{?epoch:%{epoch}:}%{version}
%%_emacs_evr %{?epoch:%{epoch}:}%{version}-%{release}
%%_emacs_sitelispdir %{site_lisp}
%%_emacs_sitestartdir %{site_start_d}
%%_emacs_bytecompile /usr/bin/emacs %bytecompargs 
EOF

%install
rm -rf %{buildroot}

make install INSTALL="%{__install} -p" DESTDIR=%{buildroot}

# let alternatives manage the symlink
rm %{buildroot}%{_bindir}/emacs


# make sure movemail isn't setgid
chmod 755 %{buildroot}%{emacs_libexecdir}/movemail

mkdir -p %{buildroot}%{site_lisp}

mv %{buildroot}%{_bindir}/{etags,etags.emacs}


mkdir -p %{buildroot}%{site_lisp}/site-start.d


# default initialization file
mkdir -p %{buildroot}%{_sysconfdir}/skel

# install pkgconfig file
mkdir -p %{buildroot}/%{pkgconfig}
install -p -m 0644 emacs.pc %{buildroot}/%{pkgconfig}

# install rpm macro definition file
mkdir -p %{buildroot}%{_sysconfdir}/rpm
install -p -m 0644 macros.emacs %{buildroot}%{_sysconfdir}/rpm/

# after everything is installed, remove info dir
rm -f %{buildroot}%{_infodir}/dir
rm %{buildroot}%{_localstatedir}/games/emacs/*

# install desktop file
mkdir -p %{buildroot}%{_datadir}/applications
desktop-file-install --dir=%{buildroot}%{_datadir}/applications \
                     %SOURCE1


#
# create file lists
#
rm -f *-filelist {common,el}-*-files

( TOPDIR=${PWD}
  cd %{buildroot}

  find .%{_datadir}/emacs/%{version}/lisp \
    .%{_datadir}/emacs/%{version}/leim \
    .%{_datadir}/emacs/site-lisp \( -type f -name '*.elc' -fprint $TOPDIR/common-lisp-none-elc-files \) -o \( -type d -fprintf $TOPDIR/common-lisp-dir-files "%%%%dir %%p\n" \) -o \( -name '*.el.gz' -fprint $TOPDIR/el-bytecomped-files -o -fprint $TOPDIR/common-not-comped-files \)

)

# put the lists together after filtering  ./usr to /usr
sed -i -e "s|\.%{_prefix}|%{_prefix}|" *-files
cat common-*-files > common-filelist
cat el-*-files common-lisp-dir-files > el-filelist


%clean
rm -rf %{buildroot}

%post
update-desktop-database &> /dev/null || :
touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ] ; then
  %{_bindir}/gtk-update-icon-cache --quiet %{_datadir}/icons/hicolor || :
fi

%postun
update-desktop-database &> /dev/null || :
touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ] ; then
  %{_bindir}/gtk-update-icon-cache --quiet %{_datadir}/icons/hicolor || :
fi

%preun
alternatives --remove emacs %{_bindir}/emacs-%{version} || :

%posttrans
#check if there is "remainder" old version, which was not deleted
if alternatives --display emacs > /dev/null; then
VER=$(alternatives --display emacs | sed -ne 's/.*emacs-\([0-9\.]\+\).*/\1/p' | head -1)
if [ ${VER} != %{version} ]; then
alternatives --remove emacs %{_bindir}/emacs-${VER} || :
fi
fi
#end check
alternatives --install %{_bindir}/emacs emacs %{_bindir}/emacs-%{version} 80 || :


%post common
for f in %{info_files}; do
  /sbin/install-info %{_infodir}/$f %{_infodir}/dir 2> /dev/null || :
done

%preun common
alternatives --remove emacs.etags %{_bindir}/etags.emacs || :
if [ "$1" = 0 ]; then
  for f in %{info_files}; do
    /sbin/install-info --delete %{_infodir}/$f %{_infodir}/dir 2> /dev/null || :
  done
fi

%posttrans common
alternatives --install %{_bindir}/etags emacs.etags %{_bindir}/etags.emacs 80 \
       --slave %{_mandir}/man1/etags.1.gz emacs.etags.man %{_mandir}/man1/etags.emacs.1.gz

%files
%defattr(-,root,root)
%{_bindir}/emacs-%{version}
%dir %{_libexecdir}/emacs
%dir %{_libexecdir}/emacs/%{version}
%dir %{emacs_libexecdir}
%{_datadir}/applications/emacs.desktop
%{_datadir}/icons/hicolor/*/apps/emacs.png
%{_datadir}/icons/hicolor/*/apps/emacs22.png
%{_datadir}/icons/hicolor/scalable/apps/emacs.svg
%{_datadir}/icons/hicolor/scalable/mimetypes/emacs-document.svg

%files -f common-filelist common
%defattr(-,root,root)
#%config(noreplace) %{_sysconfdir}/skel/.emacs
%config(noreplace) %{_sysconfdir}/rpm/macros.emacs
%doc etc/NEWS BUGS README
%exclude %{_bindir}/emacs-*
%{_bindir}/*
%{_mandir}/*/*
%{_infodir}/*
%dir %{_datadir}/emacs
%dir %{_datadir}/emacs/%{version}
%{_datadir}/emacs/%{version}/etc
%{_datadir}/emacs/%{version}/site-lisp
%{_libexecdir}/emacs

%files -f el-filelist el
%defattr(-,root,root)
%{pkgconfig}/emacs.pc
%dir %{_datadir}/emacs
%dir %{_datadir}/emacs/%{version}
