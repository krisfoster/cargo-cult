#!/usr/bin/env bash

# Install kubectl
mkdir -p $HOME/.kube
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl

# docker
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker ${USER}
sudo usermod -a -G docker $USER

# Python oci
#sudo dnf -y install python36-oci-cli

# termgraph
sudo dnf -y module install python39
sudo alternatives --set python3 /usr/bin/python3.9
python -m ensurepip --upgrade
python -m pip install termgraph
/usr/bin/python -m pip install --upgrade pip

# Install upx
sudo dnf install -y xz
wget https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz
tar -xf upx-3.96-amd64_linux.tar.xz --directory bin
rm upx-3.96-amd64_linux.tar.xz
cp bin/upx-3.96-amd64_linux/upx* bin
rm -rf bin/upx-3.96-amd64_linux/
