#!/usr/bin/env bash


_tmux_vpn(){

	vpn_status=0
	vpn_pid=$(echo "$ret" | grep -oP '(?<=vpn_pid:)([0-9]*)')

	if [[ -n $vpn_pid ]]; then
		vpn_status=1
		
	fi
	echo "$vpn_status"

}


_tmux_lp() {

	lp_status=0
	lp_ip=$(echo "$ret" | grep -oP '(?<=_ip:)([0-9\.]+)')
	LP_range=$(tmux show-environment -g | grep -oP '(?<=LP_range=)([^\s]+)')

	if [[ $lp_ip =~ "$LP_range" ]]; then
		lp_status=1
		
	fi
	echo "$lp_status"
}


_tmux_ip() {

	lp_ip=$(echo "$ret" | grep -oP '(?<=_ip:)([0-9\.]+)')
	echo "$lp_ip"

}

_tmux_hackon() {

	tf=$(tmux show-environment -g | grep -oP '(?<=current_target_file=)([^\s]+)')
    selected_target=$(cat "$current_target_file")
        
	if [[ -n "${selected_target}" ]]; then
		echo "${selected_target}"
	fi


}


if [[ "$1" =~ ^vpn$|^lp$|^ip$|^all$|^hackon$ ]]; then

	ret=$("$HOME/lpvpns/includes/ss-vpn-manager.sh" checkf)

	if [[ "$1" == 'vpn' ]]; then

		_tmux_vpn

	elif [[ "$1" == 'lp' ]]; then

		_tmux_lp

	elif [[ "$1" == 'ip' ]]; then

		_tmux_ip

	elif [[ "$1" == 'hackon' ]]; then


		_tmux_hackon

	else

		vpn=$(_tmux_vpn)
		lp=$(_tmux_lp)
		ip=$(_tmux_ip)

	fi

fi


