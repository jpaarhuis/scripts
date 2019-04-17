#!/bin/bash
PARAM1=$*

if [ -z "$PARAM1" ]; then
  PARAM1="*"  	  
else
  PARAM1=${PARAM1,,} 
fi

for FILE in ~/bin/giant-cli_$PARAM1.sh; do
  echo "*******************************************"
  echo "FILE "$FILE
  $FILE masternode status
done
