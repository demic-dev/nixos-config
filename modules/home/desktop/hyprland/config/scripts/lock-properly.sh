#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <on/off>"
  echo "Example: $0 on"
  echo "         $0 off"
  exit 1
fi

VALUE=$1

if [[ "$VALUE" != "on" && "$VALUE" != "off" ]]; then
  echo "Error: value must be 'on' or 'off'"
  exit 1
fi

if [ "$VALUE" == "on" ]; then
  hyprctl dispatch dpms on
  brightnessctl -d kbd_backlight set 25%
  echo "Turned screen and keyboard on"
fi

if [ "$VALUE" == "off" ]; then
  hyprctl dispatch dpms off
  brightnessctl -d kbd_backlight set 0
  echo "Turned screen and keyboard off"
fi

