FROM golang:1.15-alpine AS builder

ENV NAME "resizer"
WORKDIR /opt/${NAME}

RUN apk add --no-cache make libwebp-dev build-base

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN go build -o /bin/${NAME} ./cmd/${NAME}

FROM alpine:latest
ENV NAME "resizer"

RUN apk add --no-cache libwebp-dev

WORKDIR /opt/${NAME}

COPY --from=builder /bin/${NAME} ./${NAME}

CMD ./${NAME}
