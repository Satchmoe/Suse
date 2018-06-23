#!/bin/sh
lock() {
    #i3lock -c 000000			# Standard lock (black)
    #blurlock					# Simple blurlock
    ~/.config/i3/blurlock/lock	# Fancy blurlock
}

case "$1" in
    lock)
        lock
        ;;
    logout)
		pkill -KILL -u $USER	# Would not exit witout
        #i3-msg exit			# Standard exit
        ;;
    suspend)
        lock && systemctl suspend
        ;;
    hibernate)
        lock && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
