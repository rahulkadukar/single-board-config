#! /bin/bash

echo "$(date -Iseconds) $(cat /sys/class/thermal/thermal_zone0/temp)" >> temp_$(date --iso-8601).txt
