FROM debian:stretch

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential wget libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gpg --keyserver pgp.mit.edu --recv-keys 0xA7A21B0A108FF4A9 && \
    wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.12.1.tar.gz.asc && \
    wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.12.1.tar.gz && \
    gpg --verify unrealircd-4.0.12.1.tar.gz.asc unrealircd-4.0.12.1.tar.gz && \
    tar xfv unrealircd-4.0.12.1.tar.gz && \
    cd unrealircd-4.0.12.1 && \
    ./configure \
      --enable-ssl=/etc/ssl/localcerts/ \
      --with-showlistmodes \
      --with-listen=5 \
      --with-dpath=/etc/unrealircd/ \
      --with-spath=/usr/bin/unrealircd \
      --with-nick-history=2000 \
      --with-sendq=3000000 \
      --with-bufferpool=18 \
      --with-permissions=0600 \
      --with-fd-setsize=1024 \
      --enable-dynamic-linking && \
    make && \
    make install && \
    mkdir -p /usr/lib64/unrealircd/modules && \
    mv /etc/unrealircd/modules/* /usr/lib64/unrealircd/modules/ && \
    rm -rf unrealircd-4.0.12.1*


EXPOSE 6697
EXPOSE 7000

CMD ["/usr/bin/unrealircd","-F"]
