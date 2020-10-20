#!/bin/bash

cd ~/Desktop
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.1 1.4.9
sleep 15
git clone https://github.com/rolivieri/lfs272-assets.git
sleep 15
cd lfs272-assets/networkFiles
mkdir config
wget https://s3.us-east-2.amazonaws.com/lfx-start1/bootstrap.sh
chmod u+x ./bootstrap.sh 
chmod u+x start.sh teardown.sh stop.sh 
./bootstrap.sh

sleep 30s 

cd ..
rm lfs272-assets/networkFiles/bootstrap.sh ./startup.sh
rm -- "$0"