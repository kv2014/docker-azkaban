#!/bin/sh
# Wait for database to get available

AZK_VERSION="3.79.0"

DB_LOOPS="20"
MYSQL_HOST="mysql"
MYSQL_PORT="3306"
START_CMD="bin/azkaban-web-start.sh"

#wait for mysql
i=0
while ! nc $MYSQL_HOST $MYSQL_PORT >/dev/null 2>&1 < /dev/null; do
  #statements
  i=`expr $i + 1`
  if [ $i -ge $DB_LOOPS ]; then
    echo "$(date) - ${MYSQL_HOST}:${MYSQL_PORT} still not reachable, giving up"
    exit 1
  fi
  echo "$(date) - waiting for ${MYSQL_HOST}:${MYSQL_PORT}..."
  sleep 1
done

# initialize azkaban db
echo "download azkaban sql script"
curl -sLk https://github.com/kv2014/docker-azkaban/blob/master/pkgs/azkaban-db-$AZK_VERSION.tar.gz| tar xz
echo "import azkaban create-all-sql.sql to $MYSQL_HOST"
mysql -h $MYSQL_HOST -uazkaban -pazkaban azkaban < azkaban-sql-$AZK_VERSION/create-all-sql-$AZK_VERSION.sql

rm -rf azkaban-sql-$AZK_VERSION/

#start the daemon
exec $START_CMD
