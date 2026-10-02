FROM quay.io/almalinuxorg/10-minimal:10.2

RUN microdnf install -y --setopt=install_weak_deps=0 --nodocs epel-release && \
    microdnf install -y --setopt=install_weak_deps=0 --nodocs \
    fish          \
    ncurses       \
    tar           \
    xz            \
    iproute       \
    iputils       \
    yq            \
    ipcalc        \
    tcpdump       \
    bind-utils && \
    microdnf clean all

ARG HELIX_VERSION=25.07.1
RUN set -eux; \
    arch="$(uname -m)"; \
    case "${arch}" in \
      x86_64)  target="x86_64-linux"  ;; \
      aarch64) target="aarch64-linux" ;; \
      *)       echo "unsupported architecture: ${arch}" >&2; exit 1 ;; \
    esac; \
    url="https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-${target}.tar.xz"; \
    curl -fsSL -o /tmp/helix.tar.xz "${url}"; \
    # extract only the hx executable from the tarball (skip runtime/, etc.)
    tar -xJf /tmp/helix.tar.xz -C /usr/local/bin/ --strip-components=1 \
        "helix-${HELIX_VERSION}-${target}/hx"; \
    rm /tmp/helix.tar.xz; \
    # smoke test: also proves the binary matches this host's glibc AND arch
    hx --version 
ENV EDITOR=hx

ENTRYPOINT [ "/usr/bin/fish" ]
