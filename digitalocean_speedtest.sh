#!/bin/bash

# Testing download speed from DigitalOcean facilities listed in their FAQ https://www.digitalocean.com/faq
# Note that their server list might change. You're welcome to notify me or send a pull request if the script should be updated.
# Created by Niklas Berglund. Released under MIT license.
# https://github.com/niklasberglund/digitalocean_speedtest

server_name=(
	"New York City #1"
	"New York City #2"
	"San Francisco"
	"Amsterdam #1"
	"Amsterdam #2"
	"Singapore"
)

server_url=(
	"http://speedtest-ny1.digitalocean.com/10mb.test"
	"http://speedtest-nyc2.digitalocean.com/10mb.test"
	"http://speedtest-sfo1.digitalocean.com/10mb.test"
	"http://speedtest-ams1.digitalocean.com/10mb.test"
	"http://speedtest-ams2.digitalocean.com/10mb.test"
	"http://speedtest-sgp1.digitalocean.com/10mb.test"
)

server_starttransfer=()
server_speed_download=()


i=0

# measure speed
for s in "${server_name[@]}"
do
	echo "Measuring ${server_name[$i]} server download speed"	
	result=$(curl -o /dev/null --progress-bar -w "%{time_starttransfer} %{speed_download}" ${server_url[$i]})
	
	server_starttransfer[$i]=$(echo $result | cut -d " " -f 1)
	server_speed_download[$i]=$(echo $result | cut -d " " -f 2)
	server_speed_download[$i]=$(echo "scale=2; ${server_speed_download[$i]}/1024" | bc -l)
	
	echo ""
	((i++))
done


# result table
printf "\x1b[7m%-20s | %-20s | %-20s\x1b[0m\n" "Server location" "Avg. download speed" "Start time"

j=0

for s in "${server_name[@]}"
do
	printf "%-20s | %-20s | %-20s\n" "${server_name[$j]}" "${server_speed_download[$j]}kb/s" "${server_starttransfer[$j]}s"
	((j++))
done

echo ""
