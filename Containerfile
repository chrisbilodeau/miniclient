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
RUN curl -L https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-aarch64-linux.tar.xz | tar -xJ\ 
    --strip-components=1 \
    -C /usr/local/bin helix-${HELIX_VERSION}-aarch64-linux/hx

ENV EDITOR=hx

ENTRYPOINT [ "/usr/bin/fish" ]
