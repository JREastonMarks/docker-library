#!/bin/bash
set -o errexit


service ssh start
service postgresql start


$SCIDB_INSTALL_PATH/bin/scidb.py startall $SCIDB_NAME
/etc/init.d/shimsvc start


trap "$SCIDB_INSTALL_PATH/bin/scidb.py stopall $SCIDB_NAME; \
      service postgresql stop" \
     EXIT HUP INT QUIT TERM


if [ "$1" = '' ]
then
    tail -f $SCIDB_DATA_PATH/0/0/scidb.log
else
    exec "$@"
fi
