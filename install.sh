#!/bin/bash

DOTFILE_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
# insert some aliases
if ! grep -q "source $DOTFILE_DIR/bash_aliases" ~/.bash_aliases ; then
    echo "source $DOTFILE_DIR/bash_aliases" >> ~/.bash_aliases
fi
