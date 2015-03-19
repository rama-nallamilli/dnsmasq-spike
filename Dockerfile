FROM debian:wheezy

RUN \
	apt-get update && \
	apt-get install -y dnsmasq && \
	apt-get install -y dnsutils

ADD etc/dnsmasq.conf /etc/dnsmasq.conf

ENTRYPOINT ["/usr/sbin/dnsmasq", "-d"]