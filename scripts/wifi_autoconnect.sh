#!/bin/bash
# DomuPi Wi-Fi Autoconnect Script

# === LOG FILE FOR DEBUGGING ===
LOG_FILE="/var/log/domu_wifi.log"

# === LOCATION OF SAVED NETWORKS ===
CONFIG_FILE="/etc/domu/wifi_credentials.json"

# === LOG HELPER ===
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# === CHECK FOR WI-FI INTERFACE ===
INTERFACE=$(nmcli device status | grep wifi | awk '{print $1}')
if [ -z "$INTERFACE" ]; then
    log "No Wi-Fi interface found. Exiting."
    exit 1
fi

# === SCAN FOR AVAILABLE SSIDs ===
AVAILABLE_SSIDS=$(nmcli -t -f SSID device wifi list | sort -u)

# === LOAD SAVED CREDENTIALS ===
# Format in JSON: [{ "ssid": "NetworkName", "password": "yourpassword" }, ...]
KNOWN_NETWORKS=$(cat "$CONFIG_FILE" | jq -r '.[] | "\(.ssid)|\(.password)"')

CONNECTED=0

# === TRY KNOWN NETWORKS ONE BY ONE ===
while IFS= read -r pair; do
    SSID=$(echo "$pair" | cut -d'|' -f1)
    PASS=$(echo "$pair" | cut -d'|' -f2)

    if echo "$AVAILABLE_SSIDS" | grep -Fxq "$SSID"; then
        log "Trying $SSID..."
        nmcli dev wifi connect "$SSID" password "$PASS" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            log "Connected to $SSID."
            CONNECTED=1
            break
        else
            log "Failed to connect to $SSID."
        fi
    fi
done <<< "$KNOWN_NETWORKS"

# === IF NOTHING WORKS, START HOTSPOT ===
if [ $CONNECTED -eq 0 ]; then
    log "No known networks. Starting hotspot..."
    systemctl start hostapd
    systemctl start dnsmasq
fi

log "Autoconnect sequence complete."
