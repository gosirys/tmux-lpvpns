#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# source "$CURRENT_DIR/scripts/helpers.sh"

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value="$(tmux show-option -gqv "$option")"

    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}

target_sel="#($CURRENT_DIR/scripts/tmux-lpvpns-helper.sh hackon)"
lpvpns_bar="#($CURRENT_DIR/scripts/tmux-lpvpns-helper.sh lpvpns)"

target_sel_interpolation="\#{target_sel}"
lpvpns_bar_interpolation="\#{lpvpns_bar}"

do_interpolation() {
	local input=$1
    local result=""

	result=${input/$target_sel_interpolation/$target_sel}
	result=${result/$lpvpns_bar_interpolation/$lpvpns_bar}

	echo $result
}

update_tmux_option() {
	local option="$1"
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
