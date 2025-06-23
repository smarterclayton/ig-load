FROM golang:1.24
RUN \
    go install github.com/tsenart/vegeta/v12@03ca49e9b419c106db29d687827c4c823d8b8ece && \
    which vegeta
COPY . /ig-load/
WORKDIR /ig-load
