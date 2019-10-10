# Docker + services

## Install envsubst

```
$ sudo curl -L https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-`uname -s`-`uname -m` -o /usr/local/bin/envsubst
$ chmod +x /usr/local/bin/envsubst
```

## Install Docker

Install Docker:
```
$ curl -fsSL get.docker.com -o /tmp/get-docker.sh && sudo sh /tmp/get-docker.sh
```

Install docker-compose:

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

Add user to `docker` group:

```
$ sudo usermod -aG docker <your-user>
```

## Gemerate secrets

You can generate secrets or passwords for a few ways:
 * manually at [passgen.ru](http://passgen.ru/)
 * from CLI using `helloacm.com` API: `# curl https://helloacm.com/api/random/?n=32`
 * from CLI: `# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

## Generate htpasswd

htpasswd string for paste to `traefik.yml` or sample config file:

'''bash
$ echo $(htpasswd -nb <USERNAME> <PASSWORD>)
'''

htpasswd string for paste to `labels` section in `docker-compose.yml`:

'''bash
$ echo $(htpasswd -nb <USERNAME> <PASSWORD>) | sed -e s/\\$/\\$\\$/g
'''

## Run nginx

First, set required paramters:

- `DOMAIN` -- basic domain of server, all services are hosted as subsites.
- `EMAIL` --  Email address for getting updates from LetsEncrypt
- `ADMIN` -- Admin authorization for Traefik panel


```bash
$ export DOMAIN=example.com                           # Base server domain, all services are hosted as subsites 
$ export EMAIL=example@gmail.com                      # Admin email for getting updates from LetsEncrypt
$ export ADMIN=$(htpasswd -nb <USERNAME> <PASSWORD>)  # Admin authorization for Traefik panel
```

Then run nginx:

```
# docker network create nginx-proxy
# docker-compose -f docker-compose.base.yml up -d
```

## Run services

Before starting any service check this conviguration file and write sensitive data.

Run services:

```
# docker network create nginx-proxy
# docker-compose -f docker-compose.services.yml up -d <services>
```

## Services

### nginx-proxy + nginx-proxy-letsencrypt

**Common configuration file**

Default nginx-proxy config file is located at `data/nginx/conf/proxy.conf`. By default, it's empty, here is a sample configuration to redirect from `example.com` to `www.example.com`:

```
client_max_body_size 500m;


server {
    listen       80;
    server_name  example.com;
    return       301 https://www.example.com$request_uri;
}
```

**Basic auth for subdomain**

You can set basic auth for any subdomain here:

```
# cd ./data/nginx/htpasswd
# htpasswd [-c] -b ./subdomain.domain.com <username> <password>
```

For example, pass password for cadvisor:
```
# htpasswd -c -b ./monitor.domain.com admin admin
```

### registry + registry-ui

URL: http://registry.example.com
Web UI: http://ui.registry.example.com

**Common configuration**

Default registry config file is located at `/data/registry/config/config.yml`. By default, it's empty, here is a sample configuration:

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
    Access-Control-Allow-Origin: ['https://ui.registry.example.com']
    Access-Control-Allow-Methods: ['HEAD', 'GET', 'OPTIONS', 'DELETE']
    Access-Control-Allow-Headers: ['Authorization']
    Access-Control-Max-Age: [1728000]
    Access-Control-Allow-Credentials: [true]
    Access-Control-Expose-Headers: ['Docker-Content-Digest']
```

**Private registry basic auth**

Add user to private registry:
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
