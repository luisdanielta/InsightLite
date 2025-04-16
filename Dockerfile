FROM golang:1.23 AS builder

ENV POCKETBASE_DIR=/pb_server

RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/pocketbase/pocketbase.git ${POCKETBASE_DIR} && \
    cd ${POCKETBASE_DIR} && \
    go mod tidy

WORKDIR ${POCKETBASE_DIR}/examples/base
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /pocketbase

# Create a minimal runtime image
FROM alpine:latest

ENV DATA_DIR=/pb_data

COPY --from=builder /pocketbase /usr/local/bin/pocketbase
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/pocketbase /usr/local/bin/entrypoint.sh
EXPOSE 8090

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
