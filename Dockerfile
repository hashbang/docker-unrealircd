FROM debian:wheezy

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential curl

RUN curl https://www.unrealircd.org/downloads/Unreal3.2.10.4.tar.gz | tar xz && \
    mv Unreal3.2.10.4 /opt/unrealircd && \
    cd /opt/unrealircd && \
    ./configure \
      --enable-ssl=/etc/ssl/localcerts/ \
      --with-showlistmodes \
      --with-listen=5 \
      --with-dpath=/opt/unrealircd \
      --with-spath=/opt/unrealircd/src/ircd \
      --with-nick-history=2000 \
      --with-sendq=3000000 \
      --with-bufferpool=18 \
      --with-permissions=0600 \
      --with-fd-setsize=1024 \
      --enable-dynamic-linking && \
    make

# Get these certs here in advance using deployment scripts
ADD /etc/ssl/localcerts/* /etc/ssl/localcerts/

ADD config/* /opt/unrealircd/

ADD run.sh /tmp/run.sh

EXPOSE 6697

# Default command to run on boot
CMD ["/tmp/run.sh"]
