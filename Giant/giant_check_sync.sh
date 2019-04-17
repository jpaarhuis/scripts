#!/bin/bash

PARAM1=$*

if [ -z "$PARAM1" ]; then
  PARAM1="*"  	  
else
  PARAM1=${PARAM1,,} 
fi

sudo apt-get install -y jq > /dev/null 2>&1

for FILE in ~/bin/giantd_$PARAM1.sh; do
  sleep 2
  echo "****************************************************************************"
  echo FILE: " $FILE"

  GIANTSTARTPOS=$(echo $FILE | grep -b -o _)
  GIANTLENGTH=$(echo $FILE | grep -b -o .sh)
  GIANTSTARTPOS_1=$(echo ${GIANTSTARTPOS:0:2})
  GIANTSTARTPOS_1=$[GIANTSTARTPOS_1 + 1]
  GIANTNAME=$(echo ${FILE:GIANTSTARTPOS_1:${GIANTLENGTH:0:2}-GIANTSTARTPOS_1})  
  
  GIANTPID=`ps -ef | grep -i $GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
  echo "GIANTPID="$GIANTPID

  if [ -z "$GIANTPID" ]; then
    echo "Giant $GIANTNAME is STOPPED can't check if synced!"
  else
  
	  LASTBLOCK=$(~/bin/giant-cli_$GIANTNAME.sh getblockcount)
	  GETBLOCKHASH=$(~/bin/giant-cli_$GIANTNAME.sh getblockhash $LASTBLOCK)  
	  
	  LASTBLOCK=$(curl -s4 "https://explorer.giantpay.network/api/getblockcount")
	  BLOCKHASHCOINEXPLORERGIANT=$(curl -s4 "https://explorer.giantpay.network/api/getblockhash?index=$LASTBLOCK")
	  
	  WALLETVERSION=$(~/bin/giant-cli_$GIANTNAME.sh getinfo | grep -i \"version\")
	  WALLETVERSION=$(echo $WALLETVERSION | tr , " ")
	  WALLETVERSION=$(echo $WALLETVERSION | tr '"' " ")
	  WALLETVERSION=$(echo $WALLETVERSION | tr 'version : ' " ")
	  WALLETVERSION=$(echo $WALLETVERSION | tr -d ' ' )
	  
	  if ! [ "$WALLETVERSION" == "1020201" ]; then
	     echo "!!!Your wallet $GIANTNAME is OUTDATED!!!"
	  fi

	  echo "LASTBLOCK="$LASTBLOCK
	  echo "GETBLOCKHASH="$GETBLOCKHASH
	  echo "BLOCKHASHCOINEXPLORERGIANT="$BLOCKHASHCOINEXPLORERGIANT
	  echo "WALLETVERSION="$WALLETVERSION
	  
	  if [ "$GETBLOCKHASH" == "$BLOCKHASHCOINEXPLORERGIANT" ]; then
		echo "Wallet $FILE is SYNCED!"
	  else
		if [ "$BLOCKHASHCOINEXPLORERGIANT" == "Too" ]; then
		   echo "COINEXPLORERGIANT Too many requests"
		else 
		   echo "Wallet $FILE is NOT SYNCED!"
		fi
	  fi
  fi
done
