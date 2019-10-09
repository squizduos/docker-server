# Docker + services

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

You can generate it manually on [passgen.ru](http://passgen.ru/) or using helloacm.com API:

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

### registry + registry-ui

### drone + drone-agent

### cadvisor


### watchtower


