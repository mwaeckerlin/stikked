# Docker Image for Stikked — an open source paste-bin replacement

This image provides the volume only.

Connect mwaeckerlin/stikked with a mysql database, a
mwaeckerlin/php-fpm and a mwaeckerlin/nginx to get the full
functionality:

    docker run -d --name stikked-mysql \
               -e MYSQL_DATABASE=stikkeddb \
               -e MYSQL_USER=stikked \
               -e MYSQL_PASSWORD=$(pwgen 20 1) \
               -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
               mysql
    
    docker run -d --name stikked-volume \
               --link stikked-mysql:mysql \
               mwaeckerlin/stikked
    
    docker run -d --name stikked-php \
               --link stikked-mysql:mysql \
               --volumes-from stikked-volume  \
               mwaeckerlin/php-fpm
    
    docker run -d -p 8080:80 --name stikked-nginx \
               --link stikked-php:php \
               --volumes-from stikked-volume \
               mwaeckerlin/nginx

A ServiceDock configuration may look as follows:

```json
[
  {
    "name": "stikked-mysql",
    "image": "mysql",
    "ports": [],
    "env": [
      "MYSQL_DATABASE=stikkeddb",
      "MYSQL_USER=stikked",
      "MYSQL_PASSWORD=eixohphaobaigeexeigh",
      "MYSQL_RANDOM_ROOT_PASSWORD=1"
    ],
    "cmd": null,
    "volumesfrom": [],
    "links": [],
    "volumes": []
  },
  {
    "name": "stikked-volume",
    "image": "mwaeckerlin/stikked",
    "ports": [],
    "env": [],
    "cmd": null,
    "entrypoint": null,
    "volumesfrom": [],
    "links": [
      {
        "container": "stikked-mysql",
        "name": "mysql"
      }
    ],
    "volumes": []
  },
  {
    "name": "stikked-php",
    "image": "mwaeckerlin/php-fpm",
    "ports": [],
    "env": [],
    "cmd": null,
    "entrypoint": null,
    "volumesfrom": [
      "stikked-volume"
    ],
    "links": [
      {
        "container": "stikked-mysql",
        "name": "mysql"
      }
    ],
    "volumes": []
  },
  {
    "name": "stikked-nginx",
    "image": "mwaeckerlin/nginx",
    "ports": [
      {
        "internal": "80/tcp",
        "external": "8080",
        "ip": null
      }
    ],
    "env": [],
    "cmd": null,
    "entrypoint": null,
    "volumesfrom": [
      "stikked-volume"
    ],
    "links": [
      {
        "container": "stikked-php",
        "name": "php"
      }
    ],
    "volumes": []
  }
]
```