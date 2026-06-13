#!/bin/bash

DOTFILE_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
# insert some aliases
if ! grep -q "source $DOTFILE_DIR/bash_aliases" ~/.bash_aliases ; then
    echo "source $DOTFILE_DIR/bash_aliases" >> ~/.bash_aliases
fi

mkdir -p ~/.config/neomutt/
ln -sf "$DOTFILE_DIR/neomuttrc" ~/.config/neomutt/neomuttrc

if [ ! -f ~/.config/neomutt/credentials ]; then
    touch ~/.config/neomutt/credentials
    echo "Created empty ~/.config/neomutt/credentials"
fi

# Setup Vimrc wrapper
if [ ! -f ~/.vimrc ]; then
    echo "source $DOTFILE_DIR/vimrc" > ~/.vimrc
    echo "Created wrapper ~/.vimrc"
elif ! grep -q "source $DOTFILE_DIR/vimrc" ~/.vimrc ; then
    echo "source $DOTFILE_DIR/vimrc" >> ~/.vimrc
    echo "Added source line to ~/.vimrc"
fi


