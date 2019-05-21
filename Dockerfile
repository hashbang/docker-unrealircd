FROM debian:stretch

RUN groupadd -g 1000 unrealirc && \
    useradd -r -u 1000 -g unrealirc unrealirc

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential git wget libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD d11b3228e67b9d8b0684406666209343fece98c9.tar.gz .
RUN mv unrealircd-* unrealircd
WORKDIR /unrealircd
COPY config.settings config.settings
RUN ./Config -quick && \
    make && \
    make install && \
    cd . && \
    rm -r unrealircd

RUN chown -R unrealirc:unrealirc /usr/lib64/unrealircd

EXPOSE 6697
EXPOSE 7000
EXPOSE 6800
WORKDIR /
USER unrealirc

CMD ["/usr/lib64/unrealircd/bin/unrealircd","-F"]
