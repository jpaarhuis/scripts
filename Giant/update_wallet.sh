#!/bin/bash
echo 
echo "GIANT - Masternode updater"
echo ""
echo "Welcome to the GIANT Masternode update script."
echo "Wallet vX.X.X"
echo

for filename in ~/bin/giant-cli*.sh; do
  sh $filename stop
  sleep 1
done

cd ~
sudo killall -9 giantd
sudo rm -rdf /usr/bin/giant*
cd

mkdir -p GIANT_TMP
cd GIANT_TMP
wget https://github.com/newfile.zip
sudo chmod 775 newfile.zip
tar -xvzf newfile.zip

rm -f newfile.zip
sudo chmod 775 ./*
sudo mv ./giant* /usr/bin

cd ~
rm -rdf GIANT_TMP

for filename in ~/bin/giantd*.sh; do
  echo $filename
  sh $filename
  sleep 1
done

echo "Your masternode wallets are now updated!"
