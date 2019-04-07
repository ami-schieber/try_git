

check_status
if [ $? -eq 0 ] ; then
	echo "cookie expired, logging in again ..."
	log_in
	check_status
	if [ $? -eq 0 ] ; then
		echo "log in failed, aborting"
		exit 1
	fi
fi

if [ ! -f ${DEVLIST} ] ; then
	echo "device list does not exist. downloading ..."
	get_devlist
	if [ ! -f ${DEVLIST} ] ; then
		echo "failed to download device list, aborting"
		exit 1
	fi
fi

if [ -n "$COMMAND" -o -n "$QUEUE" ] ; then
	if [ "${DEVICE}" = "ALL" ] ; then
		for DEVICE in $(jq -r '.devices[] | select( .deviceFamily == "ECHO" or .deviceFamily == "KNIGHT" or .deviceFamily == "ROOK" or .deviceFamily == "WHA") | .accountName' ${DEVLIST} | sed -r 's/ /%20/g') ; do
			set_var
			if [ -n "$COMMAND" ] ; then
				echo "sending cmd:${COMMAND} to dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} customerid:${MEDIAOWNERCUSTOMERID}"
				run_cmd
			else
				echo "queue info for dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER}"
				show_queue
			fi
		done
	else
		set_var
		if [ -n "$COMMAND" ] ; then
			echo "sending cmd:${COMMAND} to dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} customerid:${MEDIAOWNERCUSTOMERID}"
			run_cmd
		else
			echo "queue info for dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER}"
			show_queue
		fi
	fi
elif [ -n "$LEMUR" ] ; then
	DEVICESERIALNUMBER=$(jq --arg device "${LEMUR}" -r '.devices[] | select(.accountName == $device and .deviceFamily == "WHA") | .serialNumber' ${DEVLIST})
	if [ -n "$DEVICESERIALNUMBER" ] ; then
		delete_multiroom
	else
		if [ -z "$CHILD" ] ; then
			echo "ERROR: ${LEMUR} is no multiroom device. Cannot delete ${LEMUR}".
			exit 1
		fi
	fi
	if [ -z "$CHILD" ] ; then
		echo "Deleted multi room dev:${LEMUR} serial:${DEVICESERIALNUMBER}"
	else
		echo "Creating multi room dev:${LEMUR} member_dev(s):${CHILD}"
		create_multiroom
	fi
	rm -f ${DEVLIST}
	get_devlist
elif [ -n "$BLUETOOTH" ] ; then
	if [ "$BLUETOOTH" = "list" -o "$BLUETOOTH" = "List" -o "$BLUETOOTH" = "LIST" ] ; then
		if [ "${DEVICE}" = "ALL" ] ; then
			for DEVICE in $(jq -r '.devices[] | select( .deviceFamily == "ECHO" or .deviceFamily == "KNIGHT" or .deviceFamily == "ROOK" or .deviceFamily == "WHA") | .accountName' ${DEVLIST} | sed -r 's/ /%20/g') ; do
				set_var
				echo "bluetooth devices for dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER}:"
				list_bluetooth
			done
		else
			set_var
			echo "bluetooth devices for dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER}:"
			list_bluetooth
		fi
	elif [ "$BLUETOOTH" = "null" ] ; then
		set_var
		echo "disconnecting dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} from bluetooth"
		disconnect_bluetooth
	else
		set_var
		echo "connecting dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} to bluetooth device:${BLUETOOTH}"
		connect_bluetooth
	fi
elif [ -n "$STATIONID" ] ; then
	set_var
	echo "playing stationID:${STATIONID} on dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} mediaownerid:${MEDIAOWNERCUSTOMERID}"
	play_radio
elif [ -n "$SONG" ] ; then
	set_var
	echo "playing library track:${SONG} on dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} mediaownerid:${MEDIAOWNERCUSTOMERID}"
	play_song
elif [ -n "$PLIST" ] ; then
	set_var
	echo "playing library playlist:${PLIST} on dev:${DEVICE} type:${DEVICETYPE} serial:${DEVICESERIALNUMBER} mediaownerid:${MEDIAOWNERCUSTOMERID}"
	play_playlist
elif [ -n "$LIST" ] ; then
	echo "the following devices exist in your account:"
	list_devices
elif [ -n "$TYPE" ] ; then
	set_var
	echo -n "the following songs exist in your ${TYPE} library: "
	show_library
elif [ -n "$PRIME" ] ; then
	set_var
	echo "the following songs exist in your PRIME ${PRIME}:"
	show_prime
elif [ -n "$ASIN" ] ; then
	set_var
	echo "playing PRIME playlist ${ASIN}"
	play_prime_playlist
elif [ -n "$SEEDID" ] ; then
	set_var
	echo "playing PRIME station ${SEEDID}"
	play_prime_station
elif [ -n "$HIST" ] ; then
	set_var
	echo "playing PRIME historical queue ${HIST}"
	play_prime_hist_queue
elif [ -n "$LASTALEXA" ] ; then
	last_alexa
else
	echo "no alexa command received"
fi

if [ -n "$LOGOFF" ] ; then
	echo "logout option present, logging off ..."
	log_off
fi
