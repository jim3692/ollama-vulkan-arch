# Ollama (Mesa/Vulkan) on Arch

This image is **vanilla Ollama** — the upstream `ollama/ollama` binary and runtimes, unmodified — repackaged on **Arch Linux** to ship the latest Mesa Vulkan drivers.

Arch's rolling release means you always get current Mesa Vulkan support for AMD (`vulkan-radeon`), Intel (`vulkan-intel`), and NVIDIA (`vulkan-nouveau`) without waiting for a distro release.

## Usage

```sh
docker run -d --device /dev/dri -p 11434:11434 \
  ghcr.io/jim3692/ollama-vulkan-arch:latest
```

## Tags

- `latest` — most recent build
- `YYYYMMDD` — daily build date

Images are rebuilt automatically every day whenever upstream changes (new ollama release, new Arch base, or Mesa package updates).

## Build locally

```sh
./build.sh
```
