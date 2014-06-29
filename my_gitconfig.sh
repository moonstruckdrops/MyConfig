#!/bin/sh
echo "*** Create gitconfig ***"

/bin/echo -n "name > "
read NAME
/bin/echo -n "email > "
read EMAIL

EDITOR=`which emacsclient`
if [ "${EDITOR}" = '' ];then
    /bin/echo -n "Editor Path > "
    read EDITOR
fi

echo "your name is "$NAME
echo "your email is "$EMAIL
echo "your editor path is "$EDITOR

/bin/echo -n "confirm[Y/n] > "
read CONFIRM

if [ "${CONFIRM}" != 'Y' ];then
    exit
fi

cat << EOF > $HOME/.gitconfig.local
 [user]
    name = ${NAME}
    email = ${EMAIL}
 [core]
    editor = ${EDITOR}
EOF

echo "complete your .gitconfig.local"
