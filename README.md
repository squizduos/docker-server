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

First run setup.sh:

```
# bash setup.sh
```

Then edit `.env` file with actual values.

Then:

```
# docker network create nginx-proxy
# docker-compose up -d <services>
```


## Generate htpasswd

```
# htpasswd registry/auth/htpasswd username
```

## Generate Drone secret

```
# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
```

Then open `.drone.env` and replace DRONE_SECRET with new secret.

## Copy data
