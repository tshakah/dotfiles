#!/usr/bin/env bash

# Copied and modified from https://gist.github.com/mortie/e725d37a71779b18e8eaaf4f8a02bf5b
# Updated to hardcode screen and stylus details, (let's be honest, they won't change).

# I have this script set to autostart in my i3 config

# Automatically rotate the screen when the device's orientation changes.
# Use 'xrandr' to get the correct display for the first argument (for example, "eDP-1"),
# and 'xinput' to get the correct input element for your touch screen, if applicable
# (for example,  "Wacom HID 486A Finger").
#
# The script depends on the monitor-sensor program from the iio-sensor-proxy package.

# Use xrandr to verify this is your tablet monitor
MONITOR=eDP

# Configure these to match your hardware (names taken from `xinput` output).
TOUCHPAD='ELAN1201:00 04F3:3098 Touchpad'
TOUCHSCREENp='ELAN9008:00 04F3:2C82 Stylus Pen (0)'
TOUCHSCREENf='ELAN9008:00 04F3:2C82'
KEYBOARD='Asus Keyboard'

function enable_inputs() {
  xinput enable $TOUCHPAD
  xinput enable $KEYBOARD
}

function disable_inputs() {
  xinput disable $TOUCHPAD
  xinput disable $KEYBOARD
}

monitor-sensor \
	| grep --line-buffered "Accelerometer orientation changed" \
	| grep --line-buffered -o ": .*" \
	| while read -r line; do
		line="${line#??}"
		if [ "$line" = "normal" ]; then
			rotate=normal
			matrix="0 0 0 0 0 0 0 0 0"
      enable_inputs
		elif [ "$line" = "left-up" ]; then
			rotate=left
			matrix="0 -1 1 1 0 0 0 0 1"
      disable_inputs
		elif [ "$line" = "right-up" ]; then
			rotate=right
			matrix="0 1 0 -1 0 1 0 0 1"
      disable_inputs
		elif [ "$line" = "bottom-up" ]; then
			rotate=inverted
			matrix="-1 0 1 0 -1 1 0 0 1"
      disable_inputs
		else
			echo "Unknown rotation: $line"
			continue
		fi

		echo $rotate
		xrandr --output "$MONITOR" --rotate "$rotate"
		xinput set-prop "$TOUCHSCREENp" --type=float "Coordinate Transformation Matrix" $matrix
		xinput set-prop "$TOUCHSCREENf" --type=float "Coordinate Transformation Matrix" $matrix
	done

