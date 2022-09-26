#!/usr/bin/env bash
sudo dnf -y install oraclelinux-developer-release-el8
sudo dnf -y install python36-oci-cli
mkdir -p ~/.oci
touch ~/.oci/config
#scp ~/.oci/config ...
#repair file permissions
# copy key