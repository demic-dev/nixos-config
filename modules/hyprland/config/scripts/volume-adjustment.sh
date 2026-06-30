#!/usr/bin/env bash

# Volume control script
# Usage: ./volume-adjustment.sh <value> <+/->
# Example: ./volume-adjustment.sh 5 +
#          ./volume-adjustment.sh 10 -

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <value> <+/->"
    echo "Example: $0 5 +"
    echo "         $0 10 -"
    exit 1
fi

VALUE=$1
OPERATOR=$2

# Validate value is a number
if ! [[ "$VALUE" =~ ^[0-9]+$ ]]; then
    echo "Error: Value must be a positive number"
    exit 1
fi

# Validate operator is + or -
if [[ "$OPERATOR" != "+" && "$OPERATOR" != "-" ]]; then
    echo "Error: Operator must be + or -"
    exit 1
fi

# Check if the default audio sink is muted
MUTE_STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")

# If muted, unmute first
if [ "$MUTE_STATUS" == "MUTED" ]; then
    echo "Audio is muted. Unmuting..."
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
fi

# Set the volume with the provided value and operator
echo "Adjusting volume by ${VALUE}%${OPERATOR}..."
wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "${VALUE}%${OPERATOR}"

# Show current volume
CURRENT_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
echo "Current volume: $CURRENT_VOLUME"
