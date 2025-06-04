#!/bin/bash

# Stop and remove any running Kafka containers (from Compose or manual runs)
echo "Stopping and removing existing Kafka containers..."
docker stop kafka || true
docker rm kafka || true
docker stop kafka-custom || true
docker rm kafka-custom || true

# Start Kafka with --cgroupns=host
echo "Starting Kafka with --cgroupns=host..."

docker run -d \
  --name kafka-custom \
  --network onlook_default \
  --restart unless-stopped \
  --cgroupns=host \
  -e KAFKA_BROKER_ID=1001 \
  -e KAFKA_CFG_RESERVED_BROKER_MAX_ID=1001 \
  -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092 \
  -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092 \
  -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e ALLOW_PLAINTEXT_LISTENER=true \
  -e KAFKA_LOG_RETENTION_MS=3600000 \
  -e KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS=300000 \
  -e KAFKA_LOG_RETENTION_HOURS=1 \
  -e KAFKA_OPTS="-Djava.security.egd=file:/dev/./urandom" \
  -v kafka-data:/bitnami/kafka \
  ghcr.io/posthog/kafka-container:v2.8.2

echo "Kafka started as 'kafka-custom' with host cgroup namespace."
