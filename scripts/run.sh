#!/usr/bin/env bash

# Load .env
set -a
source ./.env
set +a

# This script is used to build the project. It should be run from the root of the project.
BUILD_PLATFORMS="${BUILD_PLATFORMS:-linux/amd64,linux/arm64}"

build() {
  docker buildx build --platform "$BUILD_PLATFORMS" -t "$IMAGE_NAME:$IMAGE_TAG" --push .
}

deploy() {
  # Here you can add commands to deploy your application, e.g., using kubectl or docker-compose
  echo "Deploying $IMAGE_NAME:$IMAGE_TAG..."

  for file in k8s/*.yaml; do
    envsubst < "$file" | kubectl apply -f -
  done

}   

if [ -z "$1" ]; then
  echo "Usage: $0 {build|deploy}"
  exit 1
fi

if declare -f "$1" > /dev/null; then
  "$@"
  exit $?
fi
