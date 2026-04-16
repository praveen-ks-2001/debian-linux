FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates wget curl git \
        python3 python3-pip \
        tini neofetch \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    arch="$(uname -m)"; \
    case "$arch" in \
      x86_64|amd64) ttyd_asset="ttyd.x86_64" ;; \
      aarch64|arm64) ttyd_asset="ttyd.aarch64" ;; \
      *) echo "Unsupported arch: $arch" >&2; exit 1 ;; \
    esac; \
    wget -qO /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/1.7.7/${ttyd_asset}" && \
    chmod +x /usr/local/bin/ttyd

RUN echo "neofetch || true" >> /root/.bashrc && \
    echo "cd /root" >> /root/.bashrc

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/bin/bash", "-lc", "\
    echo \"export PS1='\\[\\033[01;31m\\]$USERNAME@\\h\\[\\033[00m\\]:\\[\\033[01;33m\\]\\w\\[\\033[00m\\]\\$ '\" >> /root/.bashrc && \
    /usr/local/bin/ttyd --writable -i 0.0.0.0 -p ${PORT} -c ${USERNAME}:${PASSWORD} /bin/bash"]
