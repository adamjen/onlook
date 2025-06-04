#!/bin/bash

# Define the Docker network name for PostHog services
# This should match the network Docker Compose creates for your stack (usually <project_name>_default)
# You can find this by running `docker network ls`
POSTHOG_NETWORK="onlook_default" # Adjust if your project name is different

# Stop and remove any running Kafka containers (from Compose or manual runs)
echo "Stopping and removing existing Kafka containers..."
docker stop onlook-kafka-1 || true # Stop the Compose-managed Kafka if it's running
docker rm onlook-kafka-1 || true   # Remove the Compose-managed Kafka
docker stop kafka-custom || true   # Stop the manually run Kafka
docker rm kafka-custom || true     # Remove the manually run Kafka

# Wait for Zookeeper to be ready (Kafka depends on it)
echo "Waiting for Zookeeper to be healthy..."
ZOOKEEPER_CONTAINER_NAME="onlook-zookeeper-1" # Adjust if your Zookeeper container name is different
TIMEOUT=60 # seconds
ELAPSED_TIME=0

while ! docker inspect -f '{{.State.Health.Status}}' "$ZOOKEEPER_CONTAINER_NAME" | grep -q "healthy"; do
  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Error: Zookeeper did not become healthy within $TIMEOUT seconds. Exiting."
    exit 1
  fi
  echo "Zookeeper is not yet healthy. Waiting..."
  sleep 5
  ELAPSED_TIME=$((ELAPSED_TIME + 5))
done
echo "Zookeeper is healthy. Proceeding to start Kafka."

# Start Kafka with --cgroupns=host and the JVM option.
# IMPORTANT: Using image tag v2.7.0 (with the 'v').
echo "Starting Kafka with --cgroupns=host and JVM cgroup awareness disabled (using v2.8.2 image)..."

docker run -d \
  --name kafka-custom \
  --network "$POSTHOG_NETWORK" \
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
  -e KAFKA_OPTS="-Djdk.internal.platform.cgroup.enabled=false --add-opens java.base/jdk.internal.platform.cgroupv1=ALL-UNNAMED" \
#  -e KAFKA_OPTS="-Djava.security.egd=file:/dev/./urandom -XX:+UnlockDiagnosticVMOptions -XX:NativeMemoryTracking=summary -XX:+PrintNMTStatistics -Djdk.internal.platform.cgroup.enabled=false" \
  -v kafka-data:/bitnami/kafka \
  ghcr.io/posthog/kafka-container:v2.8.2 # <--- THIS IS THE CRITICAL CHANGE
