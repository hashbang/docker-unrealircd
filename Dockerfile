FROM debian:stretch as builder

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc \
        make \
        pkg-config \
        ca-certificates \
        curl \
        libcurl4-openssl-dev \
        libc-ares-dev \
        libssl-dev \
        libtre-dev \
        libpcre2-dev \
    && \
    rm -rf /var/lib/apt/lists/*

# Meant to run and be installed as root
RUN groupadd -g 1000 unrealircd && useradd -m -r -u 1000 -g unrealircd unrealircd
USER unrealircd
WORKDIR /home/unrealircd

RUN curl -L https://github.com/unrealircd/unrealircd/archive/377fa252448f8b0e4271b0013ad4ff866e628677.tar.gz | tar -xz
WORKDIR /home/unrealircd/unrealircd-377fa252448f8b0e4271b0013ad4ff866e628677

ADD config.settings .
RUN mkdir -p /home/unrealircd/unrealircd/lib

# Add fix for PROXY module
RUN curl -o src/modules/webirc.c https://www.unrealircd.org/downloads/webirc.c

RUN ./Config -quick && make && make install
RUN rm -rf /home/unrealircd/unrealircd-377fa252448f8b0e4271b0013ad4ff866e628677

FROM debian:stretch
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libcurl4-openssl-dev \
        libc-ares-dev \
        libssl-dev \
        libtre-dev \
        libpcre2-dev \
    && \
    rm -rf /var/lib/apt/lists/*
RUN groupadd -g 1000 unrealircd && useradd -m -r -u 1000 -g unrealircd unrealircd
COPY --from=builder /home/unrealircd/unrealircd /home/unrealircd/unrealircd
RUN chown -R unrealircd:unrealircd /home/unrealircd
USER unrealircd
WORKDIR /home/unrealircd/unrealircd

EXPOSE 6697 7000 6800

CMD ["/home/unrealircd/unrealircd/unrealircd","-F"]
