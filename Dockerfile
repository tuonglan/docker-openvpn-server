FROM ubuntu:24.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y libreadline-dev net-tools iputils-ping iptables \
        openvpn=2.6.9-1ubuntu4.1

#ADD packages /packages
ADD start-openvpn-server.sh /opt/openvpn/start-openvpn-server.sh

#RUN apt install -y /packages/*.deb

WORKDIR "/opt/openvpn"

CMD ["/opt/openvpn/start-openvpn-server.sh"]
