%define binsuffix 2.7
%define libvers 2.7
# 一括置換で修正
%define libdirname lib

Summary: An interpreted, interactive, object-oriented programming language.
Name: python27
Version: 2.7.2
Release: %{?dist}.3
License: PSF
Group: Development/Languages
Source: Python-%{version}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-%{version}-root
BuildRequires: gcc make expat-devel db4-devel gdbm-devel sqlite-devel readline-devel zlib-devel bzip2-devel openssl-devel
AutoReq: no
Vendor: kurobara
Packager: kurobara

%description
Python is an interpreted, interactive, object-oriented programming
language. It incorporates modules, exceptions, dynamic typing, very high
level dynamic data types, and classes. Python combines remarkable power
with very clear syntax. It has interfaces to many system calls and
libraries, as well as to various window systems, and is extensible in C or
C++. It is also usable as an extension language for applications that need
a programmable interface. Finally, Python is portable: it runs on many
brands of UNIX, on PCs under Windows, MS-DOS, and OS/2, and on the
Mac.

%package devel
Summary: The libraries and header files needed for Python extension development.
Requires: %{name} = %{version}-%{release}
Group: Development/Libraries

%description devel
The Python programming language's interpreter can be extended with
dynamically loaded extensions and can be embedded in other programs.
This package contains the header files and libraries needed to do
these types of tasks.

Install python-devel if you want to develop Python extensions. The
python package will also need to be installed. You'll probably also
want to install the python-docs package, which contains Python
documentation.

### tkinterが有効時にコメントアウトを外す
#%package tkinter
#Summary: A graphical user interface for the Python scripting language.
#Group: Development/Languages
#Requires: %{name} = %{version}-%{release}

#%description tkinter
#The Tkinter (Tk interface) program is an graphical user interface for
#the Python scripting language.
#
#You should install the tkinter package if youd like to use a graphical
#user interface for Python programming.


%package tools
Summary: A collection of development tools included with Python.
Group: Development/Tools
Requires: %{name} = %{version}-%{release}

%description tools
The Python package includes several development tools that are used
to build python programs. This package contains a selection of those
tools, including the IDLE Python IDE.

Install python-tools if you want to use these tools to develop
Python programs. You will also need to install the python and
tkinter packages.

%prep
%setup -n Python-%{version}

### BUILD
%build
%configure \
--enable-unicode=ucs4 \
--with-signal-module \
--with-threads \
--enable-shared \
--with-pymalloc \
--enable-ipv6 \
--prefix=%{_prefix}

%{__make} %{?_smp_mflags}

##########
# INSTALL
##########
%install
# set the install path
echo '[install_scripts]' >setup.cfg
echo 'install_dir='"${RPM_BUILD_ROOT}%{_prefix}/bin" >>setup.cfg

[ -d "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_prefix}/%{libdirname}/python%{libvers}/lib-dynload
#%{__make} prefix=$RPM_BUILD_ROOT%{__prefix} altinstall
%{__make} altinstall DESTDIR="%{buildroot}"

### REPLACE PATH IN PYDOC
cd $RPM_BUILD_ROOT%{_prefix}/bin
mv pydoc pydoc.old
sed 's|#!.*|#!%{_prefix}/bin/python'%{binsuffix}'|' pydoc.old >pydoc
chmod 755 pydoc
rm -f pydoc.old
sed -i -e 's|#!.*|#!%{_prefix}/bin/python'%{binsuffix}'|' python%{libvers}-config
### add the binsuffix
cd $RPM_BUILD_ROOT%{_prefix}/bin;
for file in 2to3 pydoc python-config idle smtpd.py; do
    [ -f "$file" ] && mv "$file" "$file"%{binsuffix};
done;

# Fix permissions
chmod 644 $RPM_BUILD_ROOT%{_prefix}/%{libdirname}64/libpython%{libvers}*

########
# Tools
cd $RPM_BUILD_DIR/Python-%{version}
cp -a Tools $RPM_BUILD_ROOT%{_prefix}/%{libdirname}/python%{libvers}

### Makefileのインストール
cd $RPM_BUILD_DIR/Python-%{version}
mkdir -p $RPM_BUILD_ROOT%{_prefix}/%{libdirname}/python%{libvers}/config
#chmod 644 $RPM_BUILD_ROOT%{_prefix}/%{libdirname}/python%{libvers}/config
%{__install} -p -m0644 Makefile $RPM_BUILD_ROOT%{_prefix}/%{libdirname}/python%{libvers}/config

# MAKE FILE LISTS
rm -f mainpkg.files
find "$RPM_BUILD_ROOT""%{_prefix}"/%{libdirname}/python%{libvers} -type f |
sed "s|^${RPM_BUILD_ROOT}|/|" | grep -v -e '_tkinter.so$' >mainpkg.files
find "$RPM_BUILD_ROOT""%{_prefix}"/bin -type f -o -type l |
sed "s|^${RPM_BUILD_ROOT}|/|" |
grep -v -e '/bin/2to3%{binsuffix}$' |
grep -v -e '/bin/pydoc%{binsuffix}$' |
grep -v -e '/bin/smtpd.py%{binsuffix}$' |
grep -v -e '/bin/idle%{binsuffix}$' >>mainpkg.files
echo %{_prefix}/include/python%{libvers}/pyconfig.h >> mainpkg.files

rm -f tools.files
echo "%{_prefix}"/%{libdirname}/python%{libvers}/Tools >>tools.files
echo "%{_prefix}"/%{libdirname}/python%{libvers}/lib2to3/tests >>tools.files
echo "%{_prefix}"/bin/2to3%{binsuffix} >>tools.files
echo "%{_prefix}"/bin/pydoc%{binsuffix} >>tools.files
echo "%{_prefix}"/bin/smtpd.py%{binsuffix} >>tools.files
echo "%{_prefix}"/bin/idle%{binsuffix} >>tools.files


# fix the #! line in installed files
find "$RPM_BUILD_ROOT" -type f -print0 |
      xargs -0 grep -l /usr/local/bin/python | while read file
do
   FIXFILE="$file"
   sed 's|^#!.*python|#!%{_prefix}/bin/python'"%{binsuffix}"'|' \
         "$FIXFILE" >/tmp/fix-python-path.$$
   cat /tmp/fix-python-path.$$ >"$FIXFILE"
   rm -f /tmp/fix-python-path.$$
done

########
# CLEAN
########
%clean
[ -n "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf $RPM_BUILD_ROOT
rm -f mainpkg.files tools.files

########
# FILES
########
%files -f mainpkg.files
%defattr(-,root,root)
%doc Misc/README Misc/cheatsheet Misc/Porting
%doc LICENSE Misc/ACKS Misc/HISTORY Misc/NEWS

# OMG I'm a Lazy hack.
%{_prefix}/lib/python2.7/lib-dynload/
%{_prefix}/lib64/python2.7/lib-dynload/
%{_prefix}/lib64/pkgconfig/python-2.7.pc

%attr(755,root,root) %dir %{_prefix}/include/python%{libvers}
%attr(755,root,root) %dir %{_prefix}/lib/python%{libvers}/
%attr(755,root,root) %dir %{_prefix}/%{libdirname}/python%{libvers}/

### ライブラリ
%{_prefix}/%{libdirname}64/libpython*


%files devel
%defattr(-,root,root)
%{_prefix}/include/python%{libvers}/*.h
%{_prefix}/%{libdirname}64/python%{libvers}/config

%files -f tools.files tools
%defattr(-,root,root)

### tkinterが有効時にコメントアウトを外す
#%files tkinter
#%defattr(-,root,root)
#%{__prefix}/%{libdirname}/python%{libvers}/lib-tk
#%{__prefix}/%{libdirname}64/python%{libvers}/lib-dynload/_tkinter.so*

