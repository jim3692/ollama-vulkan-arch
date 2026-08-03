#!/usr/bin/env bash

set -euo pipefail

IMAGE="${IMAGE:-ollama-vulkan:latest}"
MODEL="${MODEL:-llama3.2:1b-instruct-q2_K}"
OLLAMA_DIR="${OLLAMA_DIR:-${HOME}/.cache/ollama-test}"
PORT="${PORT:-11434}"
CONTAINER="${CONTAINER:-ollama-test}"

cleanup() {
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker run -d --name "$CONTAINER" \
  -p "${PORT}:11434" \
  -v "${OLLAMA_DIR}:/root/.ollama" \
  "$IMAGE"

echo "waiting for ollama server..."
ready=0
for i in $(seq 1 60); do
  if curl -fsS "http://localhost:${PORT}/api/tags" >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 2
done
if [ "$ready" -ne 1 ]; then
  echo "server did not become ready" >&2
  docker logs "$CONTAINER"
  exit 1
fi
echo "server ready"

echo "pulling ${MODEL}..."
docker exec "$CONTAINER" ollama pull "$MODEL"

echo "generating with ${MODEL}..."
resp=$(curl -fsS "http://localhost:${PORT}/api/generate" \
  -H 'Content-Type: application/json' \
  -d "{\"model\":\"$MODEL\",\"prompt\":\"Say hello\",\"stream\":false}")
answer=$(printf '%s' "$resp" | jq -r '.response')
if [[ -z "$answer" || "$answer" == "null" ]]; then
  echo "empty response: $resp" >&2
  exit 1
fi

echo "ollama answered: ${answer}"
