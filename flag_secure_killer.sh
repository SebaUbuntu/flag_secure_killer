#!/bin/bash

set -e

help() {
	echo "FLAG_SECURE killer"
	echo ""
	echo "Usage:"
	echo "  flag_secure_killer.sh <package name>"
	exit
}

[ "${1}" = "" ] && help
command -v frida &> /dev/null || echo "Please install frida with pip install frida-tools"

LATEST_VERSION="14.1.3"

echo "Downloading frida-server..."
[ -f frida-server.xz ] && rm frida-server.xz
[ -f frida-server ] && rm frida-server
wget -q https://github.com/frida/frida/releases/download/${LATEST_VERSION}/frida-server-${LATEST_VERSION}-android-arm64.xz -O frida-server.xz
xz --decompress frida-server.xz
echo "Executing frida-server..."
adb root
adb shell killall frida-server || true
adb push frida-server /data/local/tmp/frida-server
adb shell "chmod +x /data/local/tmp/frida-server"
adb shell "/data/local/tmp/frida-server &" &
sleep 2
echo "Starting observator..."
echo "When you've done, type 'exit' and press ENTER"
frida -U -l flag_secure_killer.js --no-pause -f "$1"
