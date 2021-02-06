FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y libreadline-dev net-tools && \
    apt-get install -y openvpn=2.4.7-1ubuntu2

CMD "/bin/bash"
