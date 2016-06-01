#!/bin/sh

NAME="hochzehn/$(basename ${PWD})"

docker build --tag $NAME . > /dev/null

if [ $# -ne 1 ]
then
    echo "Usage: bin/run.sh RESTMQ_IP"
else
    docker run \
      --privileged \
      --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /usr/local/bin/docker:/usr/local/bin/docker \
      $NAME \
      $*
fi
