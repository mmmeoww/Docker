## Part 1. Готовый докер

1. Взял официальный докер-образ с nginx и выкачал его при помощи `docker pull nginx`.

    ![img1](./pictures/docker_pull.png)

2. Проверил наличие докер-образа через `docker images`.

    ![img2](./pictures/2.png)

3. Запустил докер-образ через `docker run -d nginx` и проверил, что образ запущен через `docker ps`. -d - нужен для запуска контейнера в фоне.

    ![img3](./pictures/3.png)

4. Посмотрел информацию о контейнере через `docker inspect [container_id|container_name]`.

    ![img4](./pictures/4.png)

5. Определил размер контейнера, список замапленных портов и ip контейнера (--size - для вывода размера контейнера, SizeRootFs - общий размер файловой системы контейнера).

    ![img4](./pictures/4_size.png)

    ![img4](./pictures/4_ports.png)

    ![img4](./pictures/4_ip.png)

6. Остановил контейнер через `docker stop [container_id|container_name]`. Проверил, что контейнер остановился через `docker ps`.

    ![img5](./pictures/5.png)

7. Запустил контейнер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду `docker run -d -p 80:80 -p 443:443 nginx`. `-p` необходим для указания мапа портов. 

    ![img5](./pictures/6.png)

8. Проверил, что в браузере по адресу `localhost:80` доступна стартовая страница nginx.

    ![img7](./pictures/7.png)

9. Перезапустил докер контейнер через `docker restart [container_id|container_name]`.

    ![img8](./pictures/8.png)

## Part 2. Операции с контейнером

1. Прочитал конфигурационный файл nginx.conf внутри докер контейнера через команду `docker exec -ti [id] bash`. `exec` - выполнение команды в контейнере, `-t` - создает псевдо-терминал, `-i` - подключает stdin, `bash` - запуск командной оболочки shell.

    ![img9](./pictures/9.png)

2. Скопировал `nginx.conf` на локальную машину. Настроил в нем по пути `/status` отдачу страницы статуса сервера nginx. `stub_status on;` в Nginx активирует встроенный модуль для отображения базовой статистики сервера.

    ![img10](./pictures/10.png)

3. Скопировал созданный файл nginx.conf внутрь докер-образа через команду `docker cp`. Перезапустил nginx внутри докер-образа через команду `exec`.

    ![img11](./pictures/11.png)

4. Проверил, что по адресу localhost:80/status отдается страничка со статусом сервера nginx.

    ![img11_stat](./pictures/11_status.png)

5. Экспортировал контейнер в файл container.tar через команду `docker export`.

    ![img12](./pictures/12.png)

6. Остановил контейнер `docker stop [id]`. Удалил образ через `docker rmi -f [image_id|repository]`, не удаляя перед этим контейнеры. `-f` - принудительное удаление. Удалил остановленный контейнер `docker rm [id]`.

    ![img13](./pictures/13.png)

7. Импортировал контейнер обратно через команду `docker import container.tar`.

    ![img14](./pictures/14.png)

    ![img15](./pictures/15.png)

8. Запустил импортированный контейнер. `-g 'daemon off;` -  вручную указывает Docker, какую команду выполнить внутри контейнера (в данном случае — запустить Nginx в foreground-режиме). Для избежания ошибки: docker: Error response from daemon: no command specified, тк нет инструкции, что запускать по умолчанию.

    ![img16](./pictures/16.png)

9. Проверил, что по адресу localhost:80/status отдается страничка со статусом сервера nginx.

    ![img17](./pictures/17.png)

## Part 3. Мини веб-сервер

1. Написал мини-сервер на C и FastCgi, который будет возвращать простейшую страничку с надписью Hello, World!. FCGI_Accept() оджидает запроса, Content-type: text/html - указывает тип возвращаемых данных

    ![img_С](./pictures/fastgci.png)

2. Написал свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080. fastcgi_pass 127.0.0.1:8080; - Перенаправляет запросы на FastCGI-сервер. include fastcgi_params; - Подключает стандартный набор параметров FastCGI.

    ![img_nginx](./pictures/miniserv_nginx.png)

3. Запустил локально nginx с написанной конфигурацией, написанный мини-сервер через spawn-fcgi на порту 8080 и перезагрузил.

    ![img_serv](./pictures/miniserver.png)

    ![img_serv_pckts](./pictures/miniserver_packets.png)

    ![img_serv1](./pictures/miniserver1.png)

4. Проверил, что в браузере по localhost:81 отдается написанная страничка.

    ![img_serv2](./pictures/miniserver2.png)

## Part 4. Свой докер

1. Написал свой докер-образ (без множественных вызовов команд RUN), который:
    * собирает исходники мини сервера на FastCgi из Части 3;
    * запускает его на 8080 порту;
    * копирует внутрь образа написанный ./nginx/nginx.conf;
    * запускает nginx.

    ![img_part4](./pictures/part4_1.png)

    ![img_part4](./pictures/part4_2.png)

2. Собрал написанный докер-образ через `docker build` при этом указав имя и тег, `-t` — флаг для задания имени и тега создаваемого образа. `.` - yказывает контекст сборки — папку, в которой Docker будет искать Dockerfile и другие файлы, необходимые для сборки.

    ![img_part4](./pictures/part4_3.png)

3. Проверил через `docker images`, что все собралось корректно.

    ![img_part4](./pictures/part4_4.png)

4. Запустил собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки ./nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а. `-v` - подключение файла с хоста в контейнер

    ![img_part4](./pictures/part4_5.png)

5. Проверил, что по localhost:80 доступна страничка написанного мини сервера.
    
    ![img_part4](./pictures/part5_5.png)

6. Дописал в `./nginx/nginx.conf` проксирование странички `/status`, по которой надо отдавать статус сервера nginx.

    ![img_part4](./pictures/part4_6.png)

7. Пересобрал докер-образ и проверил, что теперь по localhost:80/status отдается страничка со статусом nginx.

    ![img_part4](./pictures/part4_7_altern.png)

## Part 5. Dockle

1. Установил dockle и просканировал образ из предыдущего задания через `dockle [image_id|repository]`.

    ![img_part5](./pictures/part5_1.png)

2. Исправил образ так, чтобы при проверке через dockle не было ошибок (FATAL) и предупреждений (WARN). CIS-DI-0010 связано с нерекомендованным хранением gpg-ключей в официальном образе nginx,  dockle детектирует переменную окружения NGINX_GPGKEYS в процессе сборки базового образа nginx, что вызывает ошибку.

    ![img_part5](./pictures/part5_3.png)

    ![img_part5](./pictures/part5_4.png)

3. Убедился, что все по-прежнему работает. 

    ![img_part5](./pictures/part5_5.png)

## Part 6. Базовый Docker Compose

1. Установил docker-compose

    ![img_part6](./pictures/part6_1.png)

2. Написал файл `docker-compose.yml`, с помощью которого:
    * Поднимается докер-контейнер из Части 5 (он должен работать в локальной сети, т. е. не нужно использовать инструкцию EXPOSE и мапить порты на локальную машину).
    * Поднимается докер-контейнер с nginx, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера.
    * Мапится 8080 порт второго контейнера на 80 порт локальной машины.
    
    ![img_part6](./pictures/part6_yml.png)

    * depends_on: app - запускает nginx_proxy только после запуска app
    * volumes - монтирование своего конфига в контейнер.

    ![img_part6](./pictures/part6_conf.png)

3. Остановил все запущенные контейнеры. Собрал и запустил проект с помощью команд `docker-compose build` и `docker-compose up`.

    ![img_part6](./pictures/part6_2.png)

4. Проверил, что в браузере по `localhost:80` отдается написанная страничка, как и ранее.

    ![img_part6](./pictures/part6_3.png)

    ![img_part6](./pictures/part6_4.png)
