#!/bin/bash -e

export MYSQL_LINK_NAME=$(env | sed -n 's,_NAME=/.*,,p')
dbvar="${MYSQL_LINK_NAME}_ENV_MYSQL_DATABASE"
uservar="${MYSQL_LINK_NAME}_ENV_MYSQL_USER"
pwdvar="${MYSQL_LINK_NAME}_ENV_MYSQL_PASSWORD"
if test -z "${MYSQL_LINK_NAME}"; then
    echo "**** ERROR: no link to mysql database found" 1>&2
    exit 1
fi
if test -z "${!dbvar}"; then
    echo "**** ERROR: initialize mysql in ${MYSQL_LINK_NAME,,*} with -e MYSQL_DATABASE" 1>&2
    exit 1
fi
if test -z "${!uservar}"; then
    echo "**** ERROR: initialize mysql in ${MYSQL_LINK_NAME,,*} with -e MYSQL_USER" 1>&2
    exit 1
fi
if test -z "${!pwdvar}"; then
    echo "**** ERROR: initialize mysql in ${MYSQL_LINK_NAME,,*} with -e MYSQL_PASSWORD" 1>&2
    exit 1
fi
sed -e 's,\(\$config\[.db_hostname.\] = \).*;,\1'"'${MYSQL_LINK_NAME,,*}'"';,' \
    -e 's,\(\$config\[.db_database.\] = \).*;,\1'"'${!dbvar}'"';,' \
    -e 's,\(\$config\[.db_username.\] = \).*;,\1'"'${!uservar}'"';,' \
    -e 's,\(\$config\[.db_password.\] = \).*;,\1'"'${!pwdvar}'"';,' \
    -e 's,\(\$config\[.enable_captcha.\] = \).*;,\1false;,' \
    /stikked/application/config/stikked.php.dist \
    > /stikked/application/config/stikked.php
sleep infinity
