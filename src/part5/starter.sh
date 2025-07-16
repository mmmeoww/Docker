#!/bin/bash

gcc hello_world.c -o server -lfcgi
spawn-fcgi -p 8080 ./server
nginx  -g "daemon off;"