#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

cd ~/Desktop
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.1 1.4.9
sleep 15
git clone https://github.com/rolivieri/lfs272-assets.git
rm -rf lfs272-assets/setup
cd lfs272-assets/networkFiles
echo "Bootstrapping starter network..."
wget -O - https://raw.githubusercontent.com/rolivieri/lfs272-assets/main/setup/bootstrap.sh | bash
