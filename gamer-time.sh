# Gamer time 0 would revert it:
export DISPLAY=:0
case $1 in
	0)
		steam -shutdown
		sleep 1.2
		xrandr --output DP-4 --mode 3440x1440 --rate 143.92
		xrandr --output HDMI-0 --off
		pactl set-default-sink "alsa_output.pci-0000_0a_00.4.analog-stereo"
		;;
	1)
		xrandr --output DP-4 --off
		xrandr --output HDMI-0 --left-of DP-4 --auto
		pactl set-default-sink "alsa_output.pci-0000_08_00.1.hdmi-stereo"
		steam -newbigpicture steam://open/bigpicture &
		;;
	*)
		echo "Incorrect syntax";;
esac
