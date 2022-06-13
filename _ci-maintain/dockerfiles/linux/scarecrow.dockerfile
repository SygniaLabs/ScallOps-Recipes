FROM golang:1.17

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget git openssl osslsigncode mingw-w64 ; \
    go get github.com/fatih/color ; \ 
    go get github.com/yeka/zip ; \
    go get github.com/josephspurrier/goversioninfo; \
    git clone https://github.com/optiv/ScareCrow /opt/ScareCrow ; \
    chown root:root -R /opt/ScareCrow ; \
    cd /opt/ScareCrow ; \
    go get github.com/mattn/go-isatty ; \
    go build ScareCrow.go ; \
    ./ScareCrow -h
