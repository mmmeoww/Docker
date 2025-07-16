FROM nginx

WORKDIR /home/

COPY hello_world.c /home/
COPY /nginx/nginx.conf /etc/nginx/nginx.conf
COPY starter.sh /home/

RUN apt-get update && \
    apt-get install -y gcc spawn-fcgi libfcgi-dev gnupg2 && \
    useradd -m user && \
    chown -R user:user /home/ && \
    chown -R user:user /home/* && \
    chown -R user:user /var/ && \
    chown -R user:user /var/* && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
        0E98404D386FA1D9 && \
    gpg --export 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 > /usr/share/keyrings/nginx-archive-keyring.gpg && \
    gpg --export 0E98404D386FA1D9 > /usr/share/keyrings/debian-archive-keyring.gpg && \
    apt-get purge -y gnupg2 && \
    rm -rf /root/.gnupg && \
    rm -rf /var/lib/apt/lists/*
USER user    
ENTRYPOINT [ "sh", "./starter.sh" ]
