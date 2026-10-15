#!/usr/bin/env bash

## Show the active connection like a DE does: ethernet wins over wifi.
## Icon color comes from $COLOR (env-COLOR in modules.ini). Prints one line per second (tail = true).

color="${COLOR:-$1}"
icon_eth=$'歷' icon_wifi=$'直' icon_off=$'睊'

# "1234" bytes/s -> "1 KB/s"
human() {
	local b=$1
	if ((b >= 1048576)); then echo "$((b / 1048576)) MB/s"
	else echo "$((b / 1024)) KB/s"; fi
}

prev_if='' prev_rx=0
while :; do
	# ponytail: first connected device per type; multiple NICs of one type just pick the first
	dev='' name='' icon="$icon_off"
	for want in ethernet wifi; do
		line=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | grep -m1 "^[^:]*:$want:connected:")
		[[ -n $line ]] || continue
		dev=${line%%:*}
		name=${line#*:*:*:}; name=${name//\\:/:}
		[[ $want == ethernet ]] && icon="$icon_eth" || icon="$icon_wifi"
		break
	done

	if [[ -z $dev ]]; then
		label='Disconnected'
	else
		rx=$(cat "/sys/class/net/$dev/statistics/rx_bytes" 2>/dev/null || echo 0)
		[[ $dev == "$prev_if" ]] && speed=$(human $((rx - prev_rx))) || speed='0 KB/s'
		prev_if=$dev prev_rx=$rx
		label="$name $speed"
	fi

	echo "%{A1:network_menu &:}%{F$color}%{T2}$icon%{T-}%{F-} $label%{A}"
	sleep 1
done
