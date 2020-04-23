FROM golang as builder
COPY . /go/src/github.com/Draz34/go-proxy
WORKDIR /go/src/github.com/Draz34/go-proxy
RUN go get ./... && \
    CGO_ENABLED=0 GOOS=linux go build -o proxy cmd/proxy/main.go

FROM scratch
COPY --from=builder /go/src/github.com/Draz34/go-proxy/proxy /proxy
WORKDIR /
ENTRYPOINT ["./proxy"]
