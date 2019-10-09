#!/bin/bash

mkdir -p registry/auth && mv registry.htpasswd registry/auth.htpasswd

mkdir -p nginx/conf && mkdir -p nginx/html && mkdir -p nginx/vhost && mv nginx-proxy.conf nginx/conf/nginx-proxy.conf

