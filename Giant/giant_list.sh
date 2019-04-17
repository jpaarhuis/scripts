#!/bin/bash

PARAM1=$*

if [ -z "$PARAM1" ]; then
  PARAM1="*"  	  
else
  PARAM1=${PARAM1,,} 
fi

for FILE in ~/bin/giantd_$PARAM1.sh; do
  echo "*******************************************"
  COUNTER=1
  DATE=$(date '+%d.%m.%Y %H:%M:%S');
  echo "DATE="$DATE
  echo FILE: " $FILE"
  #cat $FILE
  GIANTSTARTPOS=$(echo $FILE | grep -b -o _)
  GIANTLENGTH=$(echo $FILE | grep -b -o .sh)
  # echo ${GIANTSTARTPOS:0:2}
  GIANTSTARTPOS_1=$(echo ${GIANTSTARTPOS:0:2})
  GIANTSTARTPOS_1=$[GIANTSTARTPOS_1 + 1]
  GIANTNAME=$(echo ${FILE:GIANTSTARTPOS_1:${GIANTLENGTH:0:2}-GIANTSTARTPOS_1})
  GIANTCONFPATH=$(echo "$HOME/.giant_$GIANTNAME")
  # echo $GIANTSTARTPOS_1
  # echo ${GIANTLENGTH:0:2}
  echo "NODE ALIAS: "$GIANTCONFPATH
  echo "CONF FOLDER: "$GIANTCONFPATH
done