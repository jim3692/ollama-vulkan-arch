# syntax=docker/dockerfile:1

ARG OLLAMA_IMAGE=ollama/ollama
ARG OLLAMA_TAG=latest

FROM ${OLLAMA_IMAGE}:${OLLAMA_TAG} AS ollama

FROM archlinux:latest

ARG OLLAMA_TAG
ARG SOURCE_REPO
ARG REVISION

RUN pacman-key --init \
    && pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed \
        ca-certificates \
        libcap \
        vulkan-radeon \
        vulkan-intel \
        vulkan-nouveau \
        vulkan-mesa-layers \
        vulkan-tools \
    && pacman -Scc --noconfirm \
    && rm -rf /var/cache/pacman/pkg/*

COPY --from=ollama /bin /usr/bin
COPY --from=ollama /lib/ollama /usr/lib/ollama

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV OLLAMA_HOST=0.0.0.0:11434

LABEL org.opencontainers.image.title="Ollama (Mesa/Vulkan) on Arch"
LABEL org.opencontainers.image.description="Ollama runtime repackaged on Arch Linux with Mesa Vulkan drivers only"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.version="${OLLAMA_TAG}"
LABEL org.opencontainers.image.revision="${REVISION}"

EXPOSE 11434
ENTRYPOINT ["/bin/ollama"]
CMD ["serve"]
