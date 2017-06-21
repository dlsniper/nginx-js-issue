FROM ubuntu:17.04

RUN apt-get update -y && \
    apt-get install -y wget mercurial build-essential && \
    wget -O /tmp/nginx.key http://nginx.org/keys/nginx_signing.key && \
    apt-key add /tmp/nginx.key && \
    echo "deb http://nginx.org/packages/mainline/ubuntu/ zesty nginx" >> /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/mainline/ubuntu/ zesty nginx" >> /etc/apt/sources.list.d/nginx.list && \
    apt-get update && \
    cd /tmp && \
    hg clone http://hg.nginx.org/njs && \
    wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz  && \
    tar -zxf pcre-8.40.tar.gz  && \
    cd pcre-8.40  && \
    ./configure  && \
    make  && \
    make install  && \
    cd ../  && \
    wget https://zlib.net/zlib-1.2.11.tar.gz  && \
    tar -zxf zlib-1.2.11.tar.gz  && \
    cd zlib-1.2.11  && \
    ./configure  && \
    make  && \
    make install  && \
    cd ../  && \
    wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz  && \
    tar -zxf openssl-1.0.2l.tar.gz  && \
    cd openssl-1.0.2l  && \
    ./config --prefix=/usr  && \
    make  && \
    make install  && \
    cd ../  && \
    wget http://nginx.org/download/nginx-1.12.0.tar.gz  && \
    tar zxf nginx-1.12.0.tar.gz  && \
    cd nginx-1.12.0

RUN  cd /tmp/nginx-1.12.0 && \
    ./configure \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/run/nginx.pid \
        --with-pcre=../pcre-8.40 \
        --with-zlib=../zlib-1.2.11 \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-file-aio \
        --with-threads \
        --with-http_auth_request_module \
        --with-stream \
        --with-mail=dynamic \
        --add-module=/tmp/njs/nginx && \
    make && \
    make install

EXPOSE 1883

COPY nginx.conf /etc/nginx/config/nginx.conf
COPY mqtt.conf /etc/nginx/config/mqtt.conf
COPY mqtt.js /etc/nginx/config/mqtt.js

RUN /usr/sbin/nginx -t -c /etc/nginx/config/nginx.conf

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/config/nginx.conf"]