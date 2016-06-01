#!/usr/bin/env bash

if [ $# -ne 1 ]
then
    echo "Usage: ./entrypoint.sh RESTMQ_IP"
else
    restmq=$1

    shouldRun=true
    while [ "$shouldRun" = true ]; do

        # Load json from RestMQ
        result=$(curl -s "http://$restmq:8888/q/domains")

        #Extract domain from json result
        domain=$(echo "$result" | sed -e 's/^.*"value": "\(.*\)".*$/\1/')

        if [ -z "$domain" ]; then
            shouldRun=false
        else

            # Run detectjs
            detectedjs=$(docker run --rm hochzehn/detectjs "http://$domain")

            if [ -n "$detectedjs" ]; then
                # Post detectedjs to new RestMQ queue
                curl -s -X POST -d "value=$detectedjs" "http://$restmq:8888/q/detectedjs"
            fi
        fi
    done
fi
