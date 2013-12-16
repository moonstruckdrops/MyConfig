# source code download & use this file
# git clone --recursive git://github.com/nvie/gitflow.git
# git checkout develop
# git submodule init
# git submodule update
# tar cjvf gitflow.tar.bz2

Name:           git-flow
Version:        0.4.2

Release:        1%{?dist}
Summary:        Git extensions for Vincent Driessen's branching model
Summary(fr):    Extensions Git pour le model de branches de Vincent Driessel

License:        BSD
URL:            http://nvie.com/posts/a-successful-git-branching-model/

Packager: kurobara
Vendor: kurobara


Source0:        gitflow.tar.bz2
BuildArch:      noarch

Requires:       git

%description
A collection of Git extensions to provide high-level repository operations
for Vincent Driessen's branching model (http://nvie.com/git-model).

%prep
%setup -q -n gitflow


%build
#empty build


%install
rm -rf $RPM_BUILD_ROOT
echo %{name}
mkdir -p $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0755 git-flow $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-init $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-feature $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-hotfix $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-release $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-support $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 git-flow-version $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 gitflow-common $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 gitflow-shFlags $RPM_BUILD_ROOT%{_datadir}/%{name}

mkdir -p $RPM_BUILD_ROOT%{_bindir}
ln -s %{_datadir}/%{name}/%{name} $RPM_BUILD_ROOT%{_bindir}/%{name}

%files
%doc
%{_bindir}/%{name}
%{_datadir}/%{name}
