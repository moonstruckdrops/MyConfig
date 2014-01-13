#!/bin/bash

function create() {
    dir=$1
    if [ ! -f "${dir}/.gitkeep" ]&&[ ! -z "${dir}" ]; then
        touch ${dir}/.gitkeep
        echo  "Create .gitkeep in `pwd`/${dir}"
    fi
}

function remove() {
    dir=$1
    if [ -f "${dir}/.gitkeep" ]&&[ ! -z "${dir}" ]; then
        rm ${dir}/.gitkeep
        echo  "Remove .gitkeep in `pwd`/${dir}"
    fi
}


function start() {
    command=$1
    for DIR in * ; do
        if [ -d "${DIR}" ]; then
            if [ "${command}" = "create" ]; then
                create $DIR;
            fi
            if [ "${command}" = "remove" ]; then
                remove $DIR;
            fi
            (cd "${DIR}"; start $command;)
        fi
    done
}

command=$1
if [ -z "${command}" ]; then
    command="create"
fi

if [ "${command}" != "remove" -a "${command}" != "create" ]; then
    echo "Usage : ./gitkeep.sh create or ./gitkeep.sh remove"
    exit 1
fi

if ! git rev-parse 2> /dev/null; then
    echo "Abort!!"
    echo "This directory is not git repository!!"
    exit 1
fi

start $command;
