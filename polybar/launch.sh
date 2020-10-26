#!/bin/sh

pkill polybar
polybar desktops &
polybar clock &
polybar date &
polybar music &
polybar bluetooth &
polybar weather &
polybar network &

