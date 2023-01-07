# This script will work on both (KDE) Wayland and (Any) Xorg sessions.

# KDE has a command line method to disable displays etc on wayland, so we can use that here. If on gnome you are on your own, wlroots support can likely be added.

# Determine if wayland, if yes then use it to set wayland specific stuffs
session=$(loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}')

# Lets set the env vars we need to open gui apps (steam)
# XWAYLAND HAS ITS OWN XAUTHORITY FILE AHHHHHH
if [ "$session" == 'wayland' ]; then
	export XAUTHORITY=$(ls /run/user/1000/xauth_*) 
	export WAYLAND_DISPLAY=wayland-0
	export XDG_SESSION_TYPE=wayland
	export EGL_PLATFORM=wayland
	export DISPLAY=:1
else
	export DISPLAY=:0
fi

case $1 in
        # If ./gamer-time.sh 0 is called, turn off TV and turn on monitor etc.
	0)
	        # Lets shutdown steam, then wait a little bit because steam takes a bit to close properly.
		steam -shutdown
		
		# Enable monitor and disable TV, change audio output
		if [ "$session" == 'wayland' ]; then
			kscreen-doctor output.2.mode.1 output.2.enable output.1.disable
		else
			xrandr --output DP-4 --mode 3440x1440 --rate 143.92
			xrandr --output HDMI-0 --off
		fi
		pactl set-default-sink "alsa_output.pci-0000_0a_00.4.analog-stereo"
		;;
	1)
	        # Turn off monitor and turn on TV, change audio output to hdmi, open big picture mode.
		seat=$(loginctl list-sessions | grep seat | awk '{print $1}')
		loginctl unlock-session $seat
		if [ "$session" == 'wayland' ]; then
			kscreen-doctor output.2.disable output.1.enable output.1.mode.7
		else
			xrandr --output DP-4 --off
			xrandr --output HDMI-0 --auto
		fi
		ydotool mousemove --absolute -- 1920 1080 
		pactl set-default-sink "alsa_output.pci-0000_08_00.1.hdmi-stereo"
		gamemoderun steam steam://open/bigpicture &
		;;
	*)
		echo "Incorrect syntax";;
esac
