FROM golang:1.15-alpine

RUN apk add --update --no-cache bash \
                                build-base \
                                git \
                                procps

RUN wget https://github.com/cortesi/modd/releases/download/v0.8/modd-0.8-linux64.tgz && \
        tar xvf modd-0.8-linux64.tgz && \
        mv modd-0.8-linux64/modd /usr/bin/modd && \
        rm modd-0.8-linux64.tgz

ENV GOPROXY=https://proxy.golang.org

WORKDIR /app

COPY server/go.mod .
COPY server/go.sum .
COPY server/modd.conf .
RUN go mod download

CMD ["modd"]