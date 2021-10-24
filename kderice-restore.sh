#!/bin/bash

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchDarc/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchDarc/kde.knsv
sleep 1
konsave -a kde
