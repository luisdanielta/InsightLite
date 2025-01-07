FROM golang:1.23 as builder

# Set environment variables
ENV POCKETBASE_DIR=/pb_server

# Install dependencies and clone the PocketBase repository
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/pocketbase/pocketbase.git ${POCKETBASE_DIR} && \
    cd ${POCKETBASE_DIR} && \
    go mod tidy

# Build the PocketBase binary
WORKDIR ${POCKETBASE_DIR}/examples/base
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /pocketbase

# Create a minimal runtime image
FROM alpine:latest

# Set environment variables
ENV DATA_DIR=/pb_data

# Copy the built PocketBase binary
COPY --from=builder /pocketbase /usr/local/bin/pocketbase

# Set permissions and create the data directory
RUN chmod +x /usr/local/bin/pocketbase && mkdir -p ${DATA_DIR}

# Expose the data directory as a volume
VOLUME ${DATA_DIR}

# Expose the default PocketBase port
EXPOSE 8090

# Set the entrypoint to run PocketBase
ENTRYPOINT ["pocketbase"]
CMD ["serve", "--dir", "/pb_data", "--http", "0.0.0.0:8090"]
