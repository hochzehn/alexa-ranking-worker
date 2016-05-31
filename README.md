# alexa-ranking-worker

## Usage

   docker-compose up

## Description

Program takes domains from restmq at localhost:8888/q/domains and executes docker run hochzehn/detectjs.
Result will we stored in restmq at localhost:8888/q/detectedjs

## Configuration

You can configure the URL of RestMQ in docker-compose if it's not localhost.
