FROM ubuntu:14.04
MAINTAINER fhats

RUN apt-get update
RUN apt-get install -y python-software-properties python g++ make
RUN apt-get install -y readline-common
RUN apt-get install -y build-essential
RUN apt-get install -y make
RUN apt-get install -y curl
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y git
RUN apt-get install -y libexpat1-dev

RUN ln -s /usr/bin/nodejs /usr/bin/node

ADD ./package.json /opt/tekin/package.json

WORKDIR /opt/tekin

RUN npm install

ADD ./ /opt/tekin

RUN make scripts

ENV HUBOT      /opt/tekin/bin/hubot
ENV HUBTOT_DIR /opt/tekin
ENV ADAPTER    irc
ENV HUBOT_USER root

ENV HUBOT_IRC_SERVER    irc.drinkbeyondthepossible.com
ENV HUBOT_IRC_ROOMS     #lobby
ENV HUBOT_IRC_NICK      takin
ENV HUBOT_IRC_PORT      6697
ENV HUBOT_IRC_USESSL    1
ENV HUBOT_IRC_SERVER_FAKE_SSL 1

ENTRYPOINT /opt/tekin/bin/hubot --name $HUBOT_IRC_NICK --adapter $ADAPTER >/var/log/tekin 2>&1
