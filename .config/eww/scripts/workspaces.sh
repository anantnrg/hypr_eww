#!/usr/bin/env bash

# Checks if a list ($1) contains an element ($2)
contains() {
	for e in $1; do
		[[ "$e" -eq "$2" ]] && echo 1 && return
	done
	echo 0
}

print_workspaces() {
	local buf=""
	local desktops=$(bspc query -D --names)
	local focused_desktop=$(bspc query -D -d focused --names)
	local occupied_desktops=$(bspc query -D -d .occupied --names)

	for d in $desktops; do
		if [[ "$(contains "$focused_desktop" "$d")" -eq 1 ]]; then
			local ws=$d
			local icon=""
			local class="workspace-focused"
		elif [[ "$(contains "$occupied_desktops" "$d")" -eq 1 ]]; then
			local ws=$d
			local icon=""
			local class="workspace-occupied"
		else
			local ws="$d"
			local icon=""
			local class="workspace-empty"
		fi

		local buf+="(eventbox :cursor \"pointer\" (button :class \"$class\" :onclick \"bspc desktop -f $ws\" \"$icon\"))"
	done

	echo "(box :orientation \"h\" :class \"works\" :halign \"center\" :halign \"center\" :hexpand true :vexpand true $buf)"
}

# Listen to bspwm changes
print_workspaces
bspc subscribe desktop node_transfer | while read -r _; do
	print_workspaces &
done
