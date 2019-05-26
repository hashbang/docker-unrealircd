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
RUN curl -L https://github.com/unrealircd/unrealircd/archive/377fa252448f8b0e4271b0013ad4ff866e628677.tar.gz | tar -xz
WORKDIR /unrealircd-377fa252448f8b0e4271b0013ad4ff866e628677
ADD config.settings .
RUN ./Config -quick
# Their configure script seems to delete libcares
RUN apt-get update && apt-get install --reinstall libc-ares2 && rm -rf /var/lib/apt/lists/*
RUN make

FROM debian:stretch
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        libcurl3 \
        libc-ares2 \
        libssl1.1 \
        libtre5 \
        make \
    && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /unrealircd-377fa252448f8b0e4271b0013ad4ff866e628677 /unrealircd
RUN make -C /unrealircd install && \
    rm -rf /unrealircd && \
    apt-get remove -y make && \
    groupadd -g 1000 unrealirc && \
    useradd -r -u 1000 -g unrealirc unrealirc && \
    chown -R unrealirc:unrealirc /usr/lib64/unrealircd
USER unrealirc

EXPOSE 6697 7000 6800

CMD ["/usr/lib64/unrealircd/bin/unrealircd","-F"]
