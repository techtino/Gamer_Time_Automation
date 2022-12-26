# This is run over ssh so we need to tell the script what our DISPLAY is.
export DISPLAY=:0
case $1 in
        # If ./gamer-time.sh 0 is called, turn off TV and turn on monitor etc.
	0)
	        # Lets shutdown steam, then wait a little bit because steam takes a bit to close properly.
		steam -shutdown
		sleep 1.2
		
		# Enable monitor and disable TV, change audio output
		xrandr --output DP-4 --mode 3440x1440 --rate 143.92
		xrandr --output HDMI-0 --off
		pactl set-default-sink "alsa_output.pci-0000_0a_00.4.analog-stereo"
		;;
	1)
	        # Turn off monitor and turn on TV, change audio output to hdmi, open big picture mode.
		seat=$(loginctl list-sessions | grep seat | awk '{print $1}')
		loginctl unlock-session $seat
		xrandr --output DP-4 --off
		xrandr --output HDMI-0 --auto
		ydotool mousemove --absolute -- 1920 1080 
		pactl set-default-sink "alsa_output.pci-0000_08_00.1.hdmi-stereo"
		gamemoderun steam steam://open/bigpicture &
		;;
	*)
		echo "Incorrect syntax";;
esac
