

## Generate htpasswd

```
# htpasswd -c registry/auth/htpasswd username
```

## Generate Drone secret

```
# cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
```

## Copy data

nginx_proxy.conf -> nginx/conf/my_proxy.conf