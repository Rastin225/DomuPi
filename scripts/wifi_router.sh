#!/bin/bash

# --------------------------------------------------------
# DomuPi Wi-Fi Router Startup Script
# Turns Pi into a wireless router with captive-ready routing
# --------------------------------------------------------

echo "[DomuPi] Starting Cortex..."

# Start hostapd (creates the access point)
# -B runs in background | exits if failure
sudo hostapd ../configs/hostapd.conf -B || { echo "[DomuPi] ❌ Failed to start hostapd"; exit 1; }

# Start dnsmasq (assigns IPs + handles DNS)
sudo dnsmasq -C ../configs/dnsmasq.conf || { echo "[DomuPi] ❌ Failed to start dnsmasq"; exit 1; }

# Set Pi's static IP for the hotspot interface (wlan0)
sudo ip addr add 192.168.4.1/24 dev wlan0
sudo ip link set wlan0 up

# Enable IP forwarding (lets clients reach the internet)
sudo sysctl -w net.ipv4.ip_forward=1

# NAT setup: share internet from wlan1 to wlan0 clients
sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE

# Accept traffic related to already established connections
sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow outbound traffic from hotspot clients
sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT

echo "[DomuPi] Server Online ✔"
