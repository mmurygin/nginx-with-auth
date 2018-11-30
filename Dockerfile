FROM debian:stretch

EXPOSE 80

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apt-utils \
        build-essential \
        wget \
        libpcre3 \
        libpcre3-dev \
        libpcrecpp0v5 \
        libssl-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list

RUN wget http://nginx.org/download/nginx-1.15.7.tar.gz && \
    tar zxf nginx-1.15.7.tar.gz && \
    cd nginx-1.15.7 && \
    ./configure --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --with-http_ssl_module \
        --with-http_auth_request_module && \
    make && \
    make install && \
    cd .. && \
    rm -rf nginx-1.15.7 nginx-1.15.7.tar.gz

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["nginx"]

