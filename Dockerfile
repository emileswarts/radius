FROM debian:8

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apache2 \
        libapache2-mod-php5 \
        make \
        gcc \
        wget \
        openssl \
        libnl-3-dev \
        libnl-genl-3-dev \
        libssl-dev \
        libtalloc-dev \
        libhiredis-dev \
        libcurl4-openssl-dev \
        libjson-c-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://w1.fi/releases/wpa_supplicant-2.6.tar.gz
RUN tar -xvzf wpa_supplicant-2.6.tar.gz

COPY defconfig /wpa_supplicant-2.6/wpa_supplicant/.config
RUN cd /wpa_supplicant-2.6/wpa_supplicant \
    && make eapol_test \
    && cp eapol_test /usr/bin

RUN wget ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.17.tar.gz
RUN tar -xvzf freeradius-server-3.0.17.tar.gz
RUN cd /freeradius-server-3.0.17 \
    && ./configure --with-modules="always mschap eap rest" \
    && make && make install

RUN chmod u+s /usr/bin/killall
RUN openssl dhparam -out /usr/local/etc/raddb/certs/dh 1024

EXPOSE 1812/udp
EXPOSE 1813/udp
