#!/bin/bash

set -e
if [ $# -ne 2 ] ; then
  echo "Usage: $(basename $0) OpenbravoProperties_Path Connection_Number_Threshold"
  exit 1
fi

OBPROPS=$1
CON_NUM_THRES=$2

DBNAME=$(awk -F = '/^bbdd.sid/ {print $2}' $OBPROPS)
DBUSER=$(awk -F = '/^bbdd.user/ {print $2}' $OBPROPS)
DBPASS=$(awk -F = '/^bbdd.pass/ {print $2}' $OBPROPS)
DBPORT=$(awk -F = '/^bbdd.url/ {print $2}' $OBPROPS | sed 's/.*:\([0-9]*\)/\1/')
DBHOST=$(awk -F = '/^bbdd.url/ {print $2}' $OBPROPS | cut -d':' -f3 | sed 's#//##')

run_pg_command()
{
  PGPASSWORD=$DBPASS psql -d $DBNAME -U $DBUSER -h $DBHOST -t -c "$*" 2>&1 ;
}

NUM_CON=$( run_pg_command "select count(*) from pg_stat_activity" )

echo -ne "\n[$(date)] Open connections $NUM_CON " >> pg_conn.log

if [ $NUM_CON -gt $CON_NUM_THRES ] ; then
  TIMESTAMP=$(date +"%Y-%M-%d-%H%M%S")
  echo -n "   ---  saving connection info to ${TIMESTAMP}.csv" >> pg_conn.log
  run_pg_command "copy (select xact_start, query_start, state_change, waiting, state, query from pg_stat_activity) to STDOUT with csv" > ${TIMESTAMP}.csv
fi
