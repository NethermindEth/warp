FROM node:19.0.0

RUN apt-get update && apt-get install -y libz3-dev libgmp3-dev python3-pip python-is-python3

RUN echo 'deb http://deb.debian.org/debian sid main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y -t sid install libc6

WORKDIR /usr/src/warp-stable
COPY . .

RUN yarn
RUN pip install -r requirements.txt
RUN yarn warplib
RUN ln -s /usr/src/warp-stable/bin/warp /usr/local/bin/warp

USER node
WORKDIR /dapp
ENTRYPOINT [ "warp" ]
