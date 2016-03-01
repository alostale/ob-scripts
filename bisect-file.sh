#!/bin/sh
MIN_ARGS=1
if [ $# -lt $MIN_ARGS ]; then
  echo "Usage: $(basename $0) FILE_TO_CHECK" >&2
  exit 1
fi

FILE_TO_CHECK=$1

echo "Checking if $FILE_TO_CHECK exists"

check() {
  if [ -f $FILE_TO_CHECK ]
  then
    RESULT=good
  else
    RESULT=bad
  fi

   echo "result $RESULT"

   hg bisect --$RESULT
}
while :
do
  if check | grep -q 'Testing changeset'
then
  echo
  hg bisect
else
  hg bisect
  exit 0
fi
done
