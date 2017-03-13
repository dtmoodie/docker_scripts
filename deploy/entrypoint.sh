#!/bin/bash
if [ -n "$USERID" ]
then
    sudo usermod --uid $USERID $(whoami)
    sudo groupmod --gid $USERID $(whoami)
fi
if [ -n "$APT" ]
then
    sudo apt-get -y update
    sudo apt-get -y install $APT
elif [ -n "$DPKG" ]
then
    sudo wget $DPKG
    ARRAYDPKG=(${DPKG//\// })
    sudo dpkg -i ${ARRAYDPKG[-1]}
    sudo apt-get install -y -f
fi

$1

