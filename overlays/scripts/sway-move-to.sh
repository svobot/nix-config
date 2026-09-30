#!/usr/bin/env bash
# https://gitlab.com/wef/dotfiles/-/blob/master/bin/i3-move-to
# shellcheck disable=SC2034
TIME_STAMP="20231204.121546"

# Copyright (C) 2020-2021 Bob Hepple <bob dot hepple at gmail dot com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

echo "$0 $*" >>/tmp/junk

initialise() {
	PROG=$(basename "$0")
	id=
	USAGE="Usage: $PROG [-i,--id <id>] top-right|bottom-right|bottom-left|left|right|mid-top|mid-left|mid-right|mid-bottom|centre|center

Moves a window to any corner/edge/centre (i3/sway lacks a way to do anything other than
top-left or centre).

OPTIONS:
-i|--id <id>    Moves the specific window rather than whatever has focus"

	while [[ "$1" ]]; do
		case $1 in
		-h | --help)
			echo "$USAGE"
			exit 0
			;;

		top-left | top-right | bottom-right | bottom-left | top | bottom | left | right | mid-top | mid-left | mid-right | mid-bottom | cent*)
			command="$1"
			break
			;;

		-i | --id)
			shift
			id="$1"
			shift
			;;

		*)
			echo "$PROG: bad argument" >&2
			exit 1
			;;
		esac
	done
	return 0
}

initialise "$@"
monitor_dimensions=$(swaymsg -t get_workspaces |
	jq -r '.. | select(.type?) | select(.type == "workspace") | select(.focused?) | .rect | "\(.width)x\(.height)"')
monitor_width=${monitor_dimensions%x*}
monitor_height=${monitor_dimensions#*x}

[[ "$id" ]] || id=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).id')
[[ "$id" ]] || exit 0

selection=".id == $id"
criteria="[con_id = $id] "

mapfile -t win_param < <(swaymsg -t get_tree |
	jq -r ".. | select(.type?) | select($selection)|.rect.x, .rect.y, .rect.width, .rect.height, .deco_rect.height, .type, .floating")

new_x=${win_param[0]}
new_y=${win_param[1]}
win_width=${win_param[2]}
win_height=${win_param[3]}
deco_height=${win_param[4]}
win_type=${win_param[5]} # i3 always gives "con"; sway gives "con" or "floating_con" !!
[[ "$SWAYSOCK" ]] || {
	i3_floating=${win_param[6]} # sway give "null"
	[[ $i3_floating == "user_on" || $i3_floating == "auto_on" ]] && win_type="floating_con"
}
gap=15

#echo "$win_height $win_width $deco_height"
case "$win_type" in
"floating_con")
	case $command in
	top)
		new_y=$gap
		;;

	bottom)
		new_y=$((monitor_height - win_height - deco_height - gap))
		;;

	left)
		new_x=$gap
		new_y=$((new_y - deco_height - gap))
		;;

	right)
		new_x=$((monitor_width - win_width - gap))
		new_y=$((new_y - deco_height - gap))
		;;

	mid-top)
		new_x=$(((monitor_width - win_width) / 2))
		new_y=$gap
		;;

	mid-left)
		new_x=$gap
		new_y=$(((monitor_height - win_height - deco_height) / 2))
		;;

	mid-right)
		new_x=$((monitor_width - win_width - gap))
		new_y=$(((monitor_height - win_height - deco_height) / 2))
		;;

	mid-bottom)
		new_x=$(((monitor_width - win_width) / 2))
		new_y=$((monitor_height - win_height - deco_height - gap))
		;;

	top-left)
		new_x=$gap
		new_y=$gap
		;;

	top-right)
		new_x=$((monitor_width - win_width))
		new_y=$gap
		;;

	bottom-right)
		new_x=$((monitor_width - win_width - gap))
		new_y=$((monitor_height - win_height - deco_height - gap))
		;;

	bottom-left)
		new_x=$gap
		new_y=$((monitor_height - win_height - deco_height))
		;;

	cent*)
		new_x=$(((monitor_width - win_width) / 2))
		new_y=$(((monitor_height - win_height - deco_height) / 2))
		;;

	esac

	swaymsg -q "${criteria}move position $new_x $new_y"
	;;

"con")
	case $command in
	top | mid-top)
		swaymsg -q "${criteria}move up"
		;;

	bottom | mid-bottom)
		swaymsg -q "${criteria}move down"
		;;

	left | mid-left)
		swaymsg -q "${criteria}move left"
		;;

	right | mid-right)
		swaymsg -q "${criteria}move right"
		;;

	top-left)
		swaymsg -q "${criteria}move up"
		swaymsg -q "${criteria}move left"
		;;

	top-right)
		swaymsg -q "${criteria}move up"
		swaymsg -q "${criteria}move right"
		;;

	bottom-left)
		swaymsg -q "${criteria}move down"
		swaymsg -q "${criteria}move left"
		;;

	bottom-right)
		swaymsg -q "${criteria}move right"
		swaymsg -q "${criteria}move down"
		;;

	cent*)
		: # not sure what can be done here
		;;
	esac
	;;
esac

# Local Variables:
# mode: shell-script
# time-stamp-pattern: "4/TIME_STAMP=\"%:y%02m%02d.%02H%02M%02S\""
# eval: (add-hook 'before-save-hook 'time-stamp)
# End:
