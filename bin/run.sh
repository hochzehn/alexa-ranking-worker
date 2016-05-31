#!/usr/bin/env bash

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
