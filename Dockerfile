FROM debian:wheezy

RUN apt-get update -y --fix-missing
RUN apt-get upgrade -y --fix-missing
RUN sudo apt-get install \
    build-essential \
    wget

RUN cd /tmp && \
    wget http://unrealircd.org/downloads/Unreal3.2.10.4.tar.gz && \
    tar xzvf Unreal3.2.10.4.tar.gz && \
    mv Unreal3.2.10.4 /opt/unrealircd && \
    cd /opt/unrealircd && \
    ./Config && \
    make

ADD config/* /opt/unrealircd/

ADD run.sh /tmp/run.sh

EXPOSE 6697

# Default command to run on boot
CMD ["/tmp/run.sh"]
