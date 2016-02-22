# Docker Image for Stikker — an open source paste-bin replacement

This image provides the volume only.

Connect mwaeckerlin/stikked with a mysql database, a
mwaeckerlin/php-fpm and a mwaeckerlin/nginx to get the full
functionality:

    docker run -d --name -mysql \
               -e MYSQL_DATABASE=stikkerdb \
               -e MYSQL_USER=stikker \
               -e MYSQL_PASSWORD=$(pwgen 20 1) \
               -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
               mysql
    
    docker run -d --name stikked-volume \
               --link sticked-mysql:mysql \
               mwaeckerlin/stikked
    
    docker run -d --name stikked-php \
               --link sticked-mysql:mysql \
               --volumes-from stikked-volume  \
               mwaeckerlin/php-fpm
    
    docker run -d -p 8080:80 --name stikked-nginx \
               --link stikked-php:php \
               --volumes-from stikked-volume \
               mwaeckerlin/nginx

