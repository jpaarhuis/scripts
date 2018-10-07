# DropCoin
Shell script to install a [DropCoin Masternode](https://www.dropcoinproject.io/) on a Linux server running Ubuntu 16.04 or 18.04. 
*****USE THIS AT YOUR OWN RISK*****
***
## Installation:
```
wget https://raw.githubusercontent.com/jpaarhuis/scripts/master/Dropcoin/setup.sh
chmod 755 setup.sh
./setup.sh
```
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows Wallet
1. Open the DropCoin Desktop Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **2500** **DropCoin** to **MN1**.
4. Wait for 15 confirmations.
5. Go to **Tools -> "Debug console - Console"**
6. Type the following command: **masternode genkey**
7. Type the following command: **masternode outputs**
8. Go to  ** Tools -> "Open Masternode Configuration File"
9. Add the following entry:
```
Alias Address Privkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:PORT**(Port is 18096)
* Privkey: **Masternode Private Key from Step 6**
* TxHash: **First value from Step 7**
* Output index:  **Second value from Step 7**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is unlocked.
12. Open **Debug Console** and type:
```
startmasternode "alias" "0" "MN1"
```
***

## Usage:
Start: 	
```
./bin/dropcoind_mn1.sh
```
Stop:	
```
./bin/dropcoin-cli_mn1.sh stop
```
Status:	
```
./bin/dropcoin-cli_mn1.sh mnsync status
```
Debug:	
```
tail -f ./.dropcoin_mn1/debug.log
```