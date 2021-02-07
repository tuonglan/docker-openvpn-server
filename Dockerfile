FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y libreadline-dev net-tools iputils-ping iptables && \
    apt-get install -y openvpn=2.4.7-1ubuntu2

ADD start-openvpn-server.sh /opt/openvpn/start-openvpn-server.sh

WORKDIR "/opt/openvpn"

CMD ["/opt/openvpn/start-openvpn-server.sh"]
