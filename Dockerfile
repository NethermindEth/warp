FROM ubuntu:20.04 AS builder

# Install dependencies
RUN apt update -y && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt -y install tzdata \
        libz3-dev \
        curl \
        gnupg \
        npm \
        python3-pip \
        python-is-python3 \
        libgmp3-dev

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -y && apt install -y yarn

# Upgrade npm
RUN npm install -g n
RUN n stable

# Compile source
COPY . /src
WORKDIR /src
RUN make && make compile
RUN bin/warp install
RUN yarn warplib



FROM ubuntu:20.04 AS transpiler

COPY --from=builder /src/bin/ /warp/bin
COPY --from=builder /src/build/ /warp/build
COPY package* /warp

RUN apt update -y && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt -y install tzdata \
	curl \
        libz3-dev \
        npm \
        python3-pip \
        libgmp3-dev

RUN pip3 install cairo-lang

# Upgrade npm
RUN npm install -g n
RUN n stable

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -y && apt install -y yarn

WORKDIR /warp
RUN yarn

WORKDIR /dapp
ENTRYPOINT [ "/warp/bin/warp" ]
