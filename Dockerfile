FROM crystallang/crystal:latest

ENV GOPATH $HOME/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apt-get -y update && \
    apt-get install -y curl tmux golang-go build-essential && \
    go get -u -f github.com/DarthSim/overmind && \
    git clone https://github.com/luckyframework/lucky_cli

WORKDIR lucky_cli

RUN git checkout v0.11.0 && \
    shards install && \
    crystal build src/lucky.cr --release --no-debug && \
    mv lucky /usr/local/bin && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y python-software-properties yarn && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update && apt-get install -y nodejs libpng-dev && \
    rm -rf /var/lib/apt/lists/*

ADD . /app

WORKDIR /app

RUN shards install && yarn install

EXPOSE 5000
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002

CMD ["lucky dev"]
