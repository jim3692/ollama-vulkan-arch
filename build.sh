#!/usr/bin/env bash

set -e

IMAGE="${IMAGE:-ollama-vulkan:latest}"
OLLAMA_TAG="${OLLAMA_TAG:-latest}"

docker pull archlinux:latest
docker pull "ollama/ollama:${OLLAMA_TAG}"

if [[ "${PUSH:-0}" == "1" ]]; then
  docker buildx build \
    --platform linux/amd64 \
    --pull \
    --no-cache \
    --push \
    --build-arg "OLLAMA_TAG=${OLLAMA_TAG}" \
    -t "${IMAGE}" .
else
  docker build \
    --pull \
    --no-cache \
    --build-arg "OLLAMA_TAG=${OLLAMA_TAG}" \
    -t "${IMAGE}" .
fi

echo "Built ${IMAGE}"
