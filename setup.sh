#!/bin/sh

# OS Package Setup
if [ `echo "${OSTYPE}" |grep "darwin*"` ];then
    cd darwin
    sh setup.sh
elif [ `echo "${OSTYPE}" |grep "linux*"` ];then
    # TODO
fi

# Config Setup
sh my_gitconfig.sh
