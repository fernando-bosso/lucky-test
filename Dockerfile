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
    rm -rf /var/lib/apt/lists/*

ADD . /app

WORKDIR /app
EXPOSE 3000

CMD ["bash"]
