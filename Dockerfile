FROM node:19.0.0

RUN apt-get update && apt-get install -y libz3-dev libgmp3-dev python3-pip python-is-python3

WORKDIR /usr/src/warp-stable
COPY . .

RUN yarn
RUN pip install -r requirements.txt
RUN yarn warplib
RUN ln -s /usr/src/warp-stable/bin/warp /usr/local/bin/warp

WORKDIR /dapp
ENTRYPOINT [ "warp" ]
