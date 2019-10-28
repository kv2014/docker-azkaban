#!/bin/sh
# Wait for database to get available

AZK_VERSION="3.1.0"

DB_LOOPS="20"
MYSQL_HOST="mysql"
MYSQL_PORT="3306"
START_CMD="bin/azkaban-executor-start.sh"

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

#start the daemon
exec $START_CMD
