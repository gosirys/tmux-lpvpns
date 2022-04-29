#!/usr/bin/env bash

vpn_status_icon=''
lp_status_icon=''
status_txt='[OFF]'

_tmux_hackon() {

	tf=$(tmux show-environment -g | grep -oP '(?<=current_target_file=)([^\s]+)')
    selected_target="$(cat "$current_target_file")"
        
	if [[ -n "${selected_target}" ]]; then
		printf "  ${selected_target} "
	fi

}

_tmux_lpvpns(){

	vpn_str='VPN'
	lp_str='LP'

	vpn_pid=$(echo "$ret" | grep -oP '(?<=vpn_pid:)([0-9]*)')
	#vpn_pid=22
	if [[ -n $vpn_pid ]]; then
		vpn_status_icon=''
		status_txt='[on]'

	fi
	#vpn_str+="${vpn_status_icon}"
	vpn_str+="${status_txt}"
	status_txt='[OFF]'

	lp_ip=$(echo "$ret" | grep -oP '(?<=_ip:)([0-9\.]+)')
	#lp_ip="50.201"
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

