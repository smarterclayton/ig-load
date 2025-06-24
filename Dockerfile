FROM golang:1.24
RUN \
    apt-get update && \
    apt-get -qy install lsof net-tools htop vim dnsutils && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
RUN \
    go install github.com/tsenart/vegeta/v12@03ca49e9b419c106db29d687827c4c823d8b8ece && \
    which vegeta && \
    go clean -cache -modcache
COPY config/home/* /root/
COPY . /ig-load/
WORKDIR /ig-load
