#!/bin/bash

##
## Script sync wallet using current bootstrap
##

PARAM1=$*
PARAM1=${PARAM1,,} 

sudo apt-get install -y jq > /dev/null 2>&1

if [ -z "$PARAM1" ]; then
  echo "Need to specify node alias!"
  exit -1
fi

if [ ! -f ~/bin/giantd_$PARAM1.sh ]; then
    echo "Wallet $PARAM1 not found!"
	exit -1
fi

for FILE in ~/bin/giantd_$PARAM1.sh; do
  echo "****************************************************************************"
  COUNTER=1
  DATE=$(date '+%d.%m.%Y %H:%M:%S');
  echo "DATE="$DATE
  echo FILE: " $FILE"
  GIANTSTARTPOS=$(echo $FILE | grep -b -o _)
  GIANTLENGTH=$(echo $FILE | grep -b -o .sh)./mon
  # echo ${GIANTSTARTPOS:0:2}
  GIANTSTARTPOS_1=$(echo ${GIANTSTARTPOS:0:2})
  GIANTSTARTPOS_1=$[GIANTSTARTPOS_1 + 1]
  GIANTNAME=$(echo ${FILE:GIANTSTARTPOS_1:${GIANTLENGTH:0:2}-GIANTSTARTPOS_1})
  GIANTCONFPATH=$(echo "$HOME/.giant_$GIANTNAME")
  # echo $GIANTSTARTPOS_1
  # echo ${GIANTLENGTH:0:2}
  echo CONF DIR: $GIANTCONFPATH
  
  if [ ! -d $GIANTCONFPATH ]; then
	echo "Directory $GIANTCONFPATH not found!"
	exit -1
  fi	   
  
  for (( ; ; ))
  do
    sleep 2
	
	GIANTPID=`ps -ef | grep -i _$GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
	echo "GIANTPID="$GIANTPID
	
	if [ -z "$GIANTPID" ]; then
	  echo "Giant $GIANTNAME is STOPPED can't check if synced!"
	fi
  
	LASTBLOCK=$(~/bin/giant-cli_$GIANTNAME.sh getblockcount)
	GETBLOCKHASH=$(~/bin/giant-cli_$GIANTNAME.sh getblockhash $LASTBLOCK)

	echo "LASTBLOCK="$LASTBLOCK
	echo "GETBLOCKHASH="$GETBLOCKHASH
	
	#LASTBLOCKCOINEXPLORERGIANT=$(curl -s4 https://www.coinexplorer.net/api/GIANT/block/latest)
	# echo $LASTBLOCKCOINEXPLORERGIANT
	#BLOCKHASHCOINEXPLORERGIANT=', ' read -r -a array <<< $LASTBLOCKCOINEXPLORERGIANT
	#BLOCKCOUNTCOINEXPLORERGIANT=${array[8]}
	# echo $BLOCKCOUNTCOINEXPLORERGIANT	
	#BLOCKCOUNTCOINEXPLORERGIANT=$(echo $BLOCKCOUNTCOINEXPLORERGIANT | tr , " ")
	# echo $BLOCKCOUNTCOINEXPLORERGIANT
	#BLOCKCOUNTCOINEXPLORERGIANT=$(echo $BLOCKCOUNTCOINEXPLORERGIANT | tr '"' " ")
	# echo $BLOCKCOUNTCOINEXPLORERGIANT
	# echo -e "BLOCKCOUNTCOINEXPLORERGIANT='${BLOCKCOUNTCOINEXPLORERGIANT}'"
	#BLOCKCOUNTCOINEXPLORERGIANT="$(echo -e "${BLOCKCOUNTCOINEXPLORERGIANT}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	# echo -e "BLOCKCOUNTCOINEXPLORERGIANT='${BLOCKCOUNTCOINEXPLORERGIANT}'"	
	
	#BLOCKHASHCOINEXPLORERGIANT=${array[6]}
	# echo "BLOCKHASHCOINEXPLORERGIANT="$BLOCKHASHCOINEXPLORERGIANT
	#BLOCKHASHCOINEXPLORERGIANT=$(echo $BLOCKHASHCOINEXPLORERGIANT | tr , " ")
	# echo $BLOCKHASHCOINEXPLORERGIANT
	#BLOCKHASHCOINEXPLORERGIANT=$(echo $BLOCKHASHCOINEXPLORERGIANT | tr '"' " ")
	# echo $BLOCKHASHCOINEXPLORERGIANT
	# echo -e "BLOCKHASHCOINEXPLORERGIANT='${BLOCKHASHCOINEXPLORERGIANT}'"
	#BLOCKHASHCOINEXPLORERGIANT="$(echo -e "${BLOCKHASHCOINEXPLORERGIANT}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	# echo -e "BLOCKHASHCOINEXPLORERGIANT='${BLOCKHASHCOINEXPLORERGIANT}'"

    BLOCKHASHCOINEXPLORERGIANT=$(curl -s4 https://www.coinexplorer.net/api/GIANT/block/latest | jq -r ".result.hash")	

	echo "LASTBLOCK="$LASTBLOCK
	echo "GETBLOCKHASH="$GETBLOCKHASH
	echo "BLOCKHASHCOINEXPLORERGIANT="$BLOCKHASHCOINEXPLORERGIANT


	echo "GETBLOCKHASH="$GETBLOCKHASH
	echo "BLOCKHASHCOINEXPLORERGIANT="$BLOCKHASHCOINEXPLORERGIANT

	if [ "$BLOCKHASHCOINEXPLORERGIANT" == "Too" ]; then
	   echo "COINEXPLORERGIANT Too many requests"
	   break  
	fi
	
	# Wallet is not synced
	echo $DATE" Wallet $GIANTNAME is NOT SYNCED!"
	#
	# echo $LASTBLOCKCOINEXPLORERGIANT
	#break
	
	if [ -z "$GIANTPID" ]; then
	   echo ""
	else
		#STOP 
		~/bin/giant-cli_$GIANTNAME.sh stop

		if [[ "$COUNTER" -gt 1 ]]; then
		  kill -9 $GIANTPID
		fi
	fi
	
	sleep 2 # wait 2 seconds 
	GIANTPID=`ps -ef | grep -i _$GIANTNAME | grep -i giantd | grep -v grep | awk '{print $2}'`
	echo "GIANTPID="$GIANTPID
	
	if [ -z "$GIANTPID" ]; then
	  echo "Giant $GIANTNAME is STOPPED"
	  
	  cd $GIANTCONFPATH
	  echo CURRENT CONF FOLDER: $PWD
	  echo CURRENT CONF FOLDER: $PWD
	  echo "Copy BLOCKCHAIN without conf files"
	  # wget http://blockchain.giant.vision/ -O bootstrap.zip
	  # wget http://107.191.46.178/giant/bootstrap/bootstrap.zip -O bootstrap.zip
	  # wget http://194.135.84.214/giant/bootstrap/bootstrap.zip -O bootstrap.zip
	  wget http://167.86.97.235/giant/bootstrap/bootstrap.zip -O bootstrap.zip
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
	
	COUNTER=$[COUNTER + 1]
	echo COUNTER: $COUNTER
	if [[ "$COUNTER" -gt 9 ]]; then
	  break
	fi		
  done		
done
