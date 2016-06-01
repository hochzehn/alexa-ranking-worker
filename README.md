# alexa-ranking-worker

## Usage

    docker run hochzehn/alexa-ranking-worker 127.0.0.1

## Description

Program takes domains from restmq and executes docker run hochzehn/detectjs.
Result will we stored in restmq at restmq/q/detectedjs
