#!/bin/sh

pkill polybar
polybar example &

pkill nm-applet
nm-applet &

pkill blueman-applet
blueman-applet &

pkill pasystray
pasystray &

pkill psensor
psensor &

#pkill light-locker
#light-locker &

