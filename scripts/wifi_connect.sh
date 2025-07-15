#!/bin/bash

SSID="$1"
PASSWORD="$2"

# Delete existing connection profile if it exists (prevents duplicates/conflicts)
nmcli connection delete "$SSID" 2>/dev/null

# Add and connect to the network
nmcli dev wifi connect "$SSID" password "$PASSWORD"

# Optional: wait a few seconds and check status
sleep 5
nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2
