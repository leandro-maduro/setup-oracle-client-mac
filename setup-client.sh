#!/bin/bash

set -euo pipefail

GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

echo -e "${GREEN_COLOR}Creating /opt/oracle folder...${NO_COLOR}"
sudo mkdir -p /opt/oracle

echo -e "${GREEN_COLOR}Copying files to folder...${NO_COLOR}"
sudo cp *.zip /opt/oracle

cd /opt/oracle

echo -e "${GREEN_COLOR}Decompressing files...${NO_COLOR}"
sudo unzip instantclient-basic-macos.x64-12.1.0.2.0.zip
sudo rm instantclient-basic-macos.x64-12.1.0.2.0.zip

sudo unzip instantclient-sdk-macos.x64-12.1.0.2.0.zip
sudo rm instantclient-sdk-macos.x64-12.1.0.2.0.zip

sudo unzip instantclient-sqlplus-macos.x64-12.1.0.2.0.zip
sudo rm instantclient-sqlplus-macos.x64-12.1.0.2.0.zip

cd /opt/oracle/instantclient_12_1

sudo ln -sf libclntsh.dylib.12.1 libclntsh.dylib
sudo ln -sf libocci.dylib.12.1 libocci.dylib

variables=("NLS_LANG=" "OCI_DIR=" "TNS_ADMIN=" "PATH=\$PATH:\/opt\/oracle\/instantclient_12_1")
for var in "${variables[@]}";
do
  sed -i '' "/^export $var/d" ~/.bashrc
done;

echo -e "${GREEN_COLOR}Setting environment variables...${NO_COLOR}"
echo 'export NLS_LANG="AMERICAN_AMERICA.UTF8"' >> ~/.bashrc
echo 'export OCI_DIR=/opt/oracle/instantclient_12_1' >> ~/.bashrc
echo 'export TNS_ADMIN=/opt/oracle/instantclient_12_1/network/admin' >> ~/.bashrc
echo 'export PATH=$PATH:/opt/oracle/instantclient_12_1' >> ~/.bashrc

echo -e "${GREEN_COLOR}Setting up tnsnames.ora...${NO_COLOR}"
sudo mkdir -p network/admin/
cd network/admin

sudo /bin/bash -c 'echo -e "LOCAL = \n" \
  "(DESCRIPTION = \n" \
    "\t(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) \n" \
    "\t(CONNECT_DATA = \n" \
      "\t\t(SERVER = DEDICATED) \n" \
      "\t\t(SERVICE_NAME = xe) \n" \
    "\t) \n" \
  ")" > tnsnames.ora'

source ~/.bashrc

echo -e $"${GREEN_COLOR}Finished \xF0\x9F\x98\x89 \xF0\x9F\x8D\xBB${NO_COLOR}"
