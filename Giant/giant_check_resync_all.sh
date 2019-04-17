#!/bin/bash

PARAM1=$*

sudo apt-get install -y jq > /dev/null 2>&1

if [ -z "$PARAM1" ]; then
  PARAM1="*"  	  
else
  PARAM1=${PARAM1,,} 
fi

for FILE in ~/bin/giantd_$PARAM1.sh; do
  echo "****************************************************************************"
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
  echo CONF FOLDER: $GIANTCONFPATH
  
  for (( ; ; ))
  do
    sleep 2
	
	GIANTPID=`ps -ef | grep -i _$GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
	echo "GIANTPID="$GIANTPID
	
	if [ -z "$GIANTPID" ]; then
	  echo "Giant $GIANTNAME is STOPPED can't check if synced!"
	  break
	fi
  
	LASTBLOCK=$(~/bin/giant-cli_$GIANTNAME.sh getblockcount)
	GETBLOCKHASH=$(~/bin/giant-cli_$GIANTNAME.sh getblockhash $LASTBLOCK)
    	LASTBLOCK=$(curl -s4 "https://explorer.giantpay.network/api/getblockcount")
	BLOCKHASHCOINEXPLORERGIANT=$(curl -s4 "https://explorer.giantpay.network/api/getblockhash?index=$LASTBLOCK")	

	echo "LASTBLOCK="$LASTBLOCK
	echo "GETBLOCKHASH="$GETBLOCKHASH
	echo "BLOCKHASHCOINEXPLORERGIANT="$BLOCKHASHCOINEXPLORERGIANT

	if [ "$GETBLOCKHASH" == "$BLOCKHASHCOINEXPLORERGIANT" ]; then
		echo $DATE" Wallet $GIANTNAME is SYNCED!"
		break
	else  
	    if [ "$BLOCKHASHCOINEXPLORERGIANT" == "Too" ]; then
		   echo "COINEXPLORERGIANT Too many requests"
		   break  
		fi
		
		# Wallet is not synced
		echo $DATE" Wallet $GIANTNAME is NOT SYNCED!"
		#
		# echo $LASTBLOCKCOINEXPLORERGIANT
		#break
		#STOP 
		~/bin/giant-cli_$GIANTNAME.sh stop

		if [[ "$COUNTER" -gt 1 ]]; then
		  kill -9 $GIANTPID
		fi
		
		sleep 2 # wait 2 seconds 
		GIANTPID=`ps -ef | grep -i _$GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
		echo "GIANTPID="$GIANTPID
		
		if [ -z "$GIANTPID" ]; then
		  echo "Giant $GIANTNAME is STOPPED"
		  
		  cd $GIANTCONFPATH
		  echo CURRENT CONF FOLDER: $PWD
		  echo "Copy BLOCKCHAIN without conf files"
		  wget http://207.180.227.218/giant/bootstrap.zip -O bootstrap.zip
		  # rm -R peers.dat 
		  rm -R ./database
		  rm -R ./blocks	
		  rm -R ./sporks
		  rm -R ./chainstate		  
		  unzip  bootstrap.zip
		  $FILE
		  sleep 3 # wait 3 seconds 
		  
		  GIANTPID=`ps -ef | grep -i _$GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
		  echo "GIANTPID="$GIANTPID
		  
		  if [ -z "$GIANTPID" ]; then
			echo "Giant $GIANTNAME still not running!"
		  fi
		  
		  break
		else
		  echo "Giant $GIANTNAME still running!"
		fi
	fi
	
	COUNTER=$[COUNTER + 1]
	echo COUNTER: $COUNTER
	if [[ "$COUNTER" -gt 9 ]]; then
	  break
	fi		
  done		
done
