FROM ubuntu
MAINTAINER mwaeckerlin

ENV_SOURCE_URL="https://github.com"
ENV SOURCE_PATH="/claudehohl/Stikked"

RUN apt-get install -y wget
WORKDIR /tmp
RUN export VERSION=$(wget -O- -q ${SOURCE_URL}${SOURCE_PATH}/tags \
                     | sed -n 's,.*href="${SOURCE_PATH}/archive/\(.*\)\.tar\.gz".*,\1,p;Tc;q;:c'); \
    wget -q ${SOURCE}${SOURCE_PATH}/archive/${VERSION}.tar.gz; \
    tar xf ${VERSION}.tar.gz; \
    mv Stikked-0.10.0/htdocs/themes/stikkedizr/views/view/view.php
Stikked-${VERSION}/htdocs /stikked
RUN mkdir -p /usr/share/nginx
RUN ln -s /stikked /usr/share/nginx/html

CMD sed -e 's,\(\$config[.db_hostname.] = \).*;,\1'"${}"',' \
        -e 's,\(\$config[.db_database.] = \).*;,\1'"${}"',' \
        -e 's,\(\$config[.db_username.] = \).*;,\1'"${}"',' \
        -e 's,\(\$config[.db_password.] = \).*;,\1'"${}"',' \
        /stikked/application/config/stikked.php.dist \
        > /stikked/application/config/stikked.php; \
    sleep forever

VOLUME /stikked
VOLUME /usr/share/nginx/html

