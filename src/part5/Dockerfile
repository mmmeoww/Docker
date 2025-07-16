FROM nginx

WORKDIR /home/

COPY hello_world.c /home/
COPY /nginx/nginx.conf /etc/nginx/nginx.conf
COPY starter.sh /home/

RUN apt-get update && \
    apt-get install -y gcc spawn-fcgi libfcgi-dev && \
    useradd -m user && \
    chown -R user:user /home/ && \
    chown -R user:user /home/* && \
    chown -R user:user /var/ && \
    chown -R user:user /var/* && \
    rm -rf /var/lib/apt/lists/*
USER user    
ENTRYPOINT [ "sh", "./starter.sh" ]

