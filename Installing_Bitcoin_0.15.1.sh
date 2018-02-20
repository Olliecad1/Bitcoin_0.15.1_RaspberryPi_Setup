#!/bin/sh

# Install updates
sudo apt-get update
sudo apt-get upgrade -y

# Install dependencies for Bitcoin Core (not the GUI)
sudo apt-get install autoconf libevent-dev libtool libssl-dev libboost-all-dev libminiupnpc-dev -y

# Install dependencies for Bitcoin QT (GUI)
sudo apt-get install qt4-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev -y


# Setup Swap file
sudo sed -i '16s/.*/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

mkdir ~/bin
cd ~/bin

# Install the Berkeley DB 4.8
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/

# Configuring the system and installing Berkeley DB
../dist/configure --enable-cxx
make -j4
sudo make install

# Installing Bitcoin 0.15.1
cd ~/bin
git clone -b v0.15.1 https://github.com/bitcoin/bitcoin
cd bitcoin/
./autogen.sh
./configure CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include -O2" LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib" --enable-upnp-default --with-gui=qt4
make -j2
sudo make install

# Setting up Bitcoin Data Folder
mkdir /home/pi/.bitcoin/
touch ~/.bitcoin/bitcoin.conf
printf 'listen=1\nserver=1\ndaemon=0\ntestnet=0\nmempoolexpiry=72\nmaxmempool=300\nmaxorphantx=100\nlimitfreerelay=10\nminrelaytxfee=0.0001\nmaxconnections=40\nrpcuser=BITCOIN_USER\nrpcpassword=BITCOIN_NEWPYTHON123751\nrpcport=8332' >> ~/.bitcoin/bitcoin.conf



