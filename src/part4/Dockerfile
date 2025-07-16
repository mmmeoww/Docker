FROM nginx
WORKDIR /home/
COPY hello_world.c /home/
COPY /nginx/nginx.conf /etc/nginx/nginx.conf
COPY starter.sh /home/
RUN apt-get update && apt-get install -y gcc spawn-fcgi libfcgi-dev
ENTRYPOINT [ "sh", "./starter.sh" ]