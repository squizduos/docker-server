# Docker + services

## Install envsubst

```
$ curl -L https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-`uname -s`-`uname -m` -o envsubst
$ chmod +x envsubst && sudo mv envsubst /usr/local/bin
```

## Install Docker

Install Docker:
```
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo usermod -aG docker your-user
```

Install docker-compose:

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## Run 

First add `.env` file with actual values:

```
DOMAIN=example.com         # Base server domain, all services are hosted as subsites 
EMAIL=example@gmail.com   # Admin email for getting updates from LetsEncrypt


```

Then generate configurations 

Then:

```
# docker network create nginx-proxy
# docker-compose up -d <services>
```


## Add user to registry


```
# htpasswd ./registry.htpasswd <username>
```

## Generate secret or password

You can generate it manually at [passgen.ru](http://passgen.ru/)

![passgen.ru](https://tlgur.com/d/GYMyxeNG)

or using helloacm.com API:

```
# curl https://helloacm.com/api/random/?n=32
```

or using CLI:

```
# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
```

## Generate Drone secret

Generate secret, then open `.drone.env` and replace DRONE_SECRET with new secret.

## Services

### nginx-proxy + nginx-proxy-letsencrypt

**Common configuration file**

Default nginx-proxy config file is located at `data/nginx/conf/proxy.conf`. 

```
client_max_body_size 500m;


server {
    listen       80;
    server_name  ${DOMAIN};
    return       301 https://www.${DOMAIN}$request_uri;
}
```

**Basic auth for subdomain**

```
# cd ./data/nginx/htpasswd
# htpasswd [-c] -b ./subdomain.domain.com <usernane> <password>
```

For example, pass password for cadvisor:
```
# htpasswd -c -b ./monitor.domain.com admin admin
```

### registry + registry-ui

URL: http://registry.example.com
Web UI: http://ui.registry.example.com

**Common configuration**

Default registry config file is located at `/data/registry/config/config.yml`.

```
version: 0.1
log:
  fields:
    service: registry
storage:
  delete:
    enabled: true
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
    Access-Control-Allow-Origin: ['https://ui.registry.${DOMAIN}']
    Access-Control-Allow-Methods: ['HEAD', 'GET', 'OPTIONS', 'DELETE']
    Access-Control-Allow-Headers: ['Authorization']
    Access-Control-Max-Age: [1728000]
    Access-Control-Allow-Credentials: [true]
    Access-Control-Expose-Headers: ['Docker-Content-Digest']
```

**Basic auth**

```
# htpasswd -c -b ./data/registry/auth/.htpasswd <usernane> <password>
```

htpasswd example:
```
# cat ./data/registry/auth/.htpasswd
user:$apr1$tKcKlnKE$lNVIUcWxZPhKrZ7.u5qId/
```

### drone + drone-agent

URL: http://ci.example.com
Config: `drone.env`
More: https://docs.drone.io/installation/overview/

### cadvisor

URL: http://monitor.example.com

### watchtower

Config: `watchtower.env`
