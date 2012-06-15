#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xrdb /home/gcool/.Xresources
xset b off
feh --bg-scale /home/gcool/Wallpapers/Green.jpg
/usr/bin/xscreensaver -no-splash &
xsetroot -cursor_name left_ptr
numlockx &
xmonad
