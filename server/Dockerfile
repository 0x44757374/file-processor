FROM alpine as base

RUN apk add build-base pcre pcre-dev openssl openssl-dev zlib zlib-dev git wget
RUN echo "Installing Dependencies" && \
    apk add --no-cache --virtual general-dependencies \
    autoconf \
    automake \
    byacc \
    curl-dev \
    flex \
    g++ \
    gcc \
    geoip-dev \
    git \
    libc-dev \
    libmaxminddb-dev \
    libstdc++ \
    libtool \
    libxml2-dev \
    linux-headers \
    lmdb-dev \
    make \
    openssl-dev \
    pcre-dev \
    yajl-dev \
    zlib-dev

WORKDIR /etc
RUN mkdir /var/log/nginx/

RUN git clone https://github.com/SpiderLabs/ModSecurity
RUN cd ModSecurity && git submodule init && git submodule update && ./build.sh && ./configure --with-lmbd && make && make install
RUN cd /etc && git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git && cd /etc

RUN git clone --depth 1 https://github.com/coreruleset/coreruleset.git /usr/local/owasp-modsecurity-crs


RUN wget http://nginx.org/download/nginx-1.21.5.tar.gz && \
    tar -zxvf nginx-1.*.tar.gz && \
    cd nginx-1.* && \
    ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx --prefix=/etc/nginx --user=nginx --group=nginx --with-http_v2_module --with-http_ssl_module --with-ipv6 --with-threads --with-stream --with-stream_ssl_module && \
    make modules && make && make install && \
    cd .. && rm -rf nginx-1.*

RUN apk del general-dependencies && rm -rf Modsecurity*

FROM alpine as prod
WORKDIR /etc
COPY --from=base /etc/nginx /etc/nginx
COPY --from=base /usr/local/modsecurity /usr/local/modsecurity
COPY --from=base /usr/local/owasp-modsecurity-crs /usr/local/owasp-modsecurity-crs

RUN addgroup -g 101 -S nginx && adduser -S -H -D -u 101 -G nginx -g nginx nginx

RUN mkdir /var/log/nginx/ && touch /var/log/modsec_audit.log && touch /var/log/nginx/access.log && touch /var/log/nginx/error.log
RUN mkdir /etc/nginx/http.conf.d && mkdir /etc/nginx/stream.conf.d
RUN mkdir /etc/nginx/modsec && mkdir /etc/nginx/templates
RUN mkdir /tmp/cache && mkdir /tmp/cache/app&& mkdir /tmp/cache/api
RUN mkdir /var/www &&  mkdir /var/www/error

ADD ./nginx/nginx.conf /etc/nginx/conf/nginx.conf
ADD ./nginx/owasp/crs-setup.conf /usr/local/owasp-modsecurity-crs/crs-setup.conf
ADD reload.sh /etc/nginx/sbin/reload.sh
RUN chmod +x /etc/nginx/sbin/reload.sh
RUN apk add --update libintl && apk add --virtual build_deps gettext && cp /usr/bin/envsubst /usr/local/bin/envsubst && apk del build_deps
RUN apk add --no-cache curl-dev libmaxminddb-dev libstdc++ libxml2-dev lmdb-dev geoip pcre tzdata yajl openssl

WORKDIR /

EXPOSE 80 443

CMD /etc/nginx/sbin/nginx -g 'daemon off;'