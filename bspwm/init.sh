#!/bin/sh
# Ensures that one, and only one, instance is running of the following programs

init_process() {
	pidof $1 >/dev/null
	if [[ $? -ne 0 ]] ; then
		$2 &
		echo "$2 launched"
	else
		echo "$2 is already running"
	fi
}

init_process sxhkd sxhkd
init_process picom "picom --vsync"
init_process redshift "redshift -l 34:-118 -t 6500:5500 -b 1.0:0.8"
#init_process btops btops
#init_process light-locker

init_process polybar ~/.config/polybar/launch.sh

#init_process udiskie udiskie
init_process nm-applet nm-applet
init_process blueman-tray blueman-applet
init_process pasystray pasystray

