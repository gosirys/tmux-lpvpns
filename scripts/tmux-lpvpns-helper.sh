#!/usr/bin/env bash

## LP-VPN-S
## @osiryszzz


vpn_status_icon=''
lp_status_icon=''
status_txt='[OFF]'

tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

_tmux_hackon() {

	tf=$(tmux show-environment -g | grep -oP '(?<=current_target_file=)([^\s]+)')
    selected_target="$(cat "$tf")"
    session_icon="$(tmux_get '@tmux_power_session_icon' '')"

    c_session=$(tmux display-message -p '#S')
    

	if [[ -n "${selected_target}" ]]; then

		if [[ "$selected_target" == "$c_session" ]]; then

			printf " ${session_icon}  ${selected_target} "
			#echo "0" # same target, same session
		else
			printf "  ${selected_target} "
			#echo "1" # wrong session for the current selected target
		fi

	fi

     #[fg=$TC,bg=$G06] $session_icon #S $LS#[fg=$G06,bg=$G05]${right_arrow_icon}   

}

_tmux_lpvpns(){

	vpn_str='VPN'
	lp_str='LP'

	vpn_pid=$(echo "$ret" | grep -oP '(?<=vpn_pid:)([0-9]*)')

	if [[ -n $vpn_pid ]]; then
		vpn_status_icon=''
		status_txt='[on]'
	fi

	vpn_str+="${status_txt}"
	status_txt='[OFF]'

	lp_ip=$(echo "$ret" | grep -oP '(?<=_ip:)([0-9\.]+)')
	LP_range=$(tmux show-environment -g | grep -oP '(?<=LP_range=)([^\s]+)')

	if [[ -n $vpn_pid ]] && [[ $lp_ip =~ $LP_range ]]; then
		lp_status_icon=''
		status_txt="[on](${lp_ip})"
	fi
	#lp_str+="${lp_status_icon} (${lp_ip})"
	lp_str+="${status_txt}"
	printf " ${vpn_str}  ${lp_str} "
}


if [[ "$1" =~ ^hackon$|^lpvpns$ ]]; then

	ret=$("$HOME/lpvpns/includes/ss-vpn-manager.sh" checkf)

	if [[ "$1" == 'hackon' ]]; then

		_tmux_hackon

	elif [[ "$1" == 'lpvpns' ]]; then

		_tmux_lpvpns
	fi
fi


## EOF
