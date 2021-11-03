#!/bin/bash

STATUS=$(cat /sys/class/power_supply/BAT0/status)
BATT=$(cat /sys/class/power_supply/BAT0/capacity)
echo "$BATT%"
