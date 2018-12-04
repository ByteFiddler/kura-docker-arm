FROM resin/rpi-raspbian:stretch

ARG KURA_VERSION=4.0.0

RUN apt-get update && \
	apt-get --yes install	apt-utils && \
	apt-get --yes install	bluetooth \
							gdebi-core \
							openjdk-8-jre-headless \
							procps \
							usbutils && \
	wget -q http://download.eclipse.org/kura/releases/${KURA_VERSION}/kura_${KURA_VERSION}_raspberry-pi-2-3-nn_installer.deb && \
	yes | gdebi kura_${KURA_VERSION}_raspberry-pi-2-3-nn_installer.deb && \
	rm kura_${KURA_VERSION}_raspberry-pi-2-3-nn_installer.deb && \
	apt-get remove gdebi && \
	apt-get clean

COPY start.sh /

CMD ["/start.sh"]
