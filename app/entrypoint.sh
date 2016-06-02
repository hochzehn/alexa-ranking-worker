#!/usr/bin/env bash

set -e

# Allow termination
_term() {
  exit 255
}

trap _term SIGINT SIGTERM

if [ $# -ne 1 ]
then
    echo "Usage: ./entrypoint.sh RESTMQ_IP"
else
    restmq=$1

    while :
    do
        # Load json from RestMQ
        result=$(curl -s "http://$restmq:8888/q/domains")

        #Extract domain from json result
        domain=$(echo "$result" | sed -e 's/^.*"value": "\(.*\)".*$/\1/')

        if [ -z "$domain" ]; then
            # Wait 1 second until next try
            sleep 1
        else

            # Run detectjs
            detectedjs=$(detectjs "http://$domain")

            if [ -n "$detectedjs" ]; then
                # Post detectedjs to new RestMQ queue
                curl -s -X POST -d "value=$detectedjs" "http://$restmq:8888/q/detectedjs"
            fi
        fi
    done
fi
