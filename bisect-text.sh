#!/bin/sh
MIN_ARGS=2
if [ $# -lt $MIN_ARGS ]; then
  echo "Usage: $(basename $0) FILE TEXT_TO_FIND" >&2
  exit 1
fi
FILE=$1
shift
TEXT_TO_FIND=$*
check() {
   grep -q "$TEXT_TO_FIND" $FILE && RESULT=good || RESULT=bad
   echo $RESULT

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
