#!/usr/bin/env bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

## Start picom
picom -CGb &

## Polkit authentication
lxpolkit &

## Set last saved with xwallpaper
xargs xwallpaper --stretch < ~/wallpapers

## Speed xrate up
xset r rate 300 50 &

## Remove mouse when idle
unclutter &

## Launch nitrogen before launching plank
nitrogen --restore &

## Set Colemak Keyboard
setxkbmap us -variant colemak &

## Start notifications
dunst &

exec bspwm
