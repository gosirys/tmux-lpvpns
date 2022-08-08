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


tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# get_tmux_option() {
#     local option=$1
#     local default_value=$2
#     local option_value="$(tmux show-option -gqv "$option")"

#     if [[ -z "$option_value" ]]; then
#         echo "$default_value"
#     else
#         echo "$option_value"
#     fi
# }

# set_tmux_option() {
#     local option=$1
#     local value=$2
#     tmux set-option -gq "$option" "$value"
# }

# _tmux_hackon
# -> 0: same target and session
# -> 1: different session for target
# _tmux_hackon() {

# 	tf=$(tmux show-environment -g | grep -oP '(?<=current_target_file=)([^\s]+)')
#     selected_target="$(cat "$tf")"
#     session_icon="$(tmux_get '@tmux_power_session_icon' '')"

#     c_session=$(tmux display-message -p '#S')
    

# 	if [[ -n "${selected_target}" ]]; then

# 		if [[ "$selected_target" == "$c_session" ]]; then

# 			printf " ${session_icon}  ${selected_target} "
# 			#echo "0" # same target, same session
# 		else
# 			printf "  ${selected_target} "
# 			#echo "1" # wrong session for the current selected target
# 		fi

# 	fi

#      #[fg=$TC,bg=$G06] $session_icon #S $LS#[fg=$G06,bg=$G05]${right_arrow_icon}   

# }



# #_tmux_lpvpns
# # 0 -> vpn and lp ON
# # 1 -> vpn on, lp off
# # 2 -> vpn and lp off
# _tmux_lpvpns(){

# 	# vpn_str='VPN'
# 	# lp_str='LP'

# 	# off_icon=''
# 	# on_icon=''

# 	print_str=''
# 	vpn_pid=$(echo "$ret" | grep -oP '(?<=vpn_pid:)([0-9]*)')

# 	if [[ -n $vpn_pid ]]; then
# 		# vpn_status_icon=''
# 		# status_txt='[on]'

# 		lp_ip=$(echo "$ret" | grep -oP '(?<=_ip:)([0-9\.]+)')
# 		LP_range=$(tmux show-environment -g | grep -oP '(?<=LP_range=)([^\s]+)')

# 		if [[ $lp_ip =~ $LP_range ]]; then
# 			# VPN and LP ON
# 			# lp_status_icon=''
# 			# status_txt="[on](${lp_ip})"

# 			print_str='LPVPN[]'
# 		else
# 			# VPN ON, LP OFF
# 			print_str='VPN[] LP[]'
# 		fi
# 	else
# 		# VPN, LP OFF
# 		print_str='LPVPN[]'
# 	fi

# 	# vpn_str+="${status_txt}"
# 	# status_txt='[OFF]'

# 	#lp_str+="${lp_status_icon} (${lp_ip})"
# 	# lp_str+="${status_txt}"
# 	printf " ${print_str} "
# }





# ret=$("$HOME/lpvpns/includes/ss-vpn-manager.sh" checkf)


# # _tmux_hackon
# # -> 0: same target and session
# # -> 1: different session for target

# #_tmux_lpvpns
# # 0 -> vpn and lp ON
# # 1 -> vpn on, lp off
# # 2 -> vpn and lp off

# # target_sel_raw="$(_tmux_hackon)"
# # lpvpns_bar_raw="$(_tmux_lpvpns)"





# target_sel="#($(_tmux_hackon))"
# lpvpns_bar="#($(_tmux_lpvpns))"

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
