#!/usr/bin/env bash

set -euo pipefail

usage() {
	echo "usage: osd-brightness <raise|lower|(+-)number> [all|internal|external]" >&2
	exit 2
}

[ "$#" -ge 1 ] || usage
action=$1
scope=${2:-all}

for dev in /sys/class/backlight/*; do
	[ -e "$dev" ] || continue
	# The backlight sits under its DRM connector in sysfs, and the connector
	# name is also the compositor's output name.
	[[ $(readlink -f "$dev") =~ card[0-9]+-([A-Za-z]+-[0-9]+) ]] || continue
	connector=${BASH_REMATCH[0]}
	output=${BASH_REMATCH[1]}
	case "$scope" in
		all) ;;
		internal) [[ $output == eDP-* ]] || continue ;;
		external) [[ $output == eDP-* ]] && continue ;;
		*) usage ;;
	esac
	read -r enabled <"/sys/class/drm/$connector/enabled"
	[ "$enabled" = enabled ] || continue
	swayosd-client --brightness "$action" --device "$(basename "$dev")" --monitor "$output"
done
