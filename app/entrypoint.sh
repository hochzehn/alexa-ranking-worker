#!/usr/bin/env bash

set -e

# Allow termination
_term() {
  exit 255
}

trap _term SIGINT SIGTERM

#######################################################
# Parameters

if [ $# -ne 1 ]
then
    echo "Usage: ./entrypoint.sh RESTMQ_IP"
    exit 1
fi

restmq=$1

#######################################################
# Constants

seconds_until_next_try=5

#######################################################
# Main loop

while :
do
    # Load json from RestMQ
    result=$(curl -s "http://$restmq:8888/q/domains")

    #Extract domain from json result
    domain=$(echo "$result" | sed -e 's/^.*"value": "\(.*\)".*$/\1/')

    if [ -z "$domain" ]; then
        # Wait until next try
        sleep "$seconds_until_next_try"
    else

        # Run detectjs
        detectedjs=$(detectjs "http://$domain")

        if [ -n "$detectedjs" ]; then
            # Post detectedjs to new RestMQ queue
            curl -s -X POST -d "value=$detectedjs" "http://$restmq:8888/q/detectedjs"
        fi
    fi
done
