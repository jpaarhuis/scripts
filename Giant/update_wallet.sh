#!/bin/bash
echo 
echo "GIANT - Masternode updater"
echo ""
echo "Welcome to the GIANT Masternode update script."
echo "Wallet v1.3.0"
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
wget https://github.com/GiantPay/GiantCore/releases/download/1.3.0.0/giant-1.3.0-x86_64-linux-gnu.tar.gz
chmod -R 755 giant-1.3.0-x86_64-linux-gnu.tar.gz
tar -xzf giant-1.3.0-x86_64-linux-gnu.tar.gz

rm -f giant-1.3.0-x86_64-linux-gnu.tar.gz
cd ./giant-1.3.0/bin
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
