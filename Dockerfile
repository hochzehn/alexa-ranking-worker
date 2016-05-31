FROM phusion/baseimage:0.9.15

RUN apt-get update && apt-get install wget unzip parallel

ADD bin/ bin/

ENTRYPOINT ["bin/run.sh"]
