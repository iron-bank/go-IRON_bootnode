# Build GMC in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-IRON
RUN cd /go-IRON && make iron

# Pull iron into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-IRON/build/bin/iron /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["iron"]
