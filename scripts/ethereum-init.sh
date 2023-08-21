#!/bin/bash

VOLUME_PATH="/dev/nvme1n1"
MOUNT_POINT="/data"

# Format Volume if not formatted
if grep -q "$VOLUME_PATH: data" <<< "sudo file -s $VOLUME_PATH"; then
    sudo mkfs.ext4 $VOLUME_PATH
fi
sudo mkdir /data
sudo echo "$VOLUME_PATH $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
sudo mount -a

cd /home/ubuntu

sudo -u ubuntu bash << EOF_SCRIPT

# Install dependencies
sudo apt-get update
sudo apt-get install build-essential ca-certificates curl gnupg -y

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker

# Setup Ethereum Nodes
git clone https://github.com/a41-official/ethereum-node.git
cd ethereum-node
cp .env.sample .env
sed -i 's/^#NETWORK=goerli/NETWORK=mainnet/; s/^#GETH_VERSION=/GETH_VERSION=v1.12.0/; s/^#CC_CHECKPOINT_SYNC_URL=/CC_CHECKPOINT_SYNC_URL=https:\/\/mainnet.checkpoint.sigp.io/' .env
echo "ETH2_NETWORK=mainnet" >> .env

# Create data symlink
sudo ln -sf /data \$(pwd)/data

# Init
docker compose -f docker-compose.yaml -f deployments/geth-lighthouse-lighthouse.yaml up -d

EOF_SCRIPT