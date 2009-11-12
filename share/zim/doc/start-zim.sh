#! /bin/bash

# This script uses wmctrl to raise zim window to current desktop
# (ie: wmctrl is required)

# Written by Federico Stafforini - Januari 2008
# Updated by Jaap Karssenberg

PIDFILE=$HOME/.cache/zim.pid	#note: make sure path exists!

if [ -e $PIDFILE ]; then
	PID=`cat $PIDFILE`
	WINDOW_ID_LINE=$(wmctrl -p -l | grep " $PID")
	if [ "$WINDOW_ID_LINE" = "" ]; then
		# wmctrl cannot find window: zim is in trayicon or
		#                            has exited abnormally
		ZIM_PS=$(ps -p $PID)
		if [ "$?" != "0" ]; then
			# process identified by pid does not exist,
			# zim must have crashed?
			echo "Zim seems to have exited abnormally."  \
			     "Starting new zim instance"
			exec zim --pidfile $PIDFILE --no-daemon && exit
		else
			# zim must be in tray, use kill -USR1
			# to raise first, then get window id line again
			kill -USR1 `cat $PIDFILE`
			sleep 1
			WINDOW_ID_LINE=$(wmctrl -p -l | grep " $PID")
		fi
	fi
	WINDOW_ID=${WINDOW_ID_LINE:0:10}
	echo "Zim is already running," \
	     "raising current instance to active desktop"
	wmctrl -i -R $WINDOW_ID
else
	echo "No running instance of zim found, starting new one"
	exec zim --pidfile $PIDFILE --no-daemon
fi

