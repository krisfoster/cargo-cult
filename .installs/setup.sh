#!/usr/bin/env bash

# Create a user bin dir - aleady added to PATH in base bashrc
mkdir -p ~/bin

# Update packages
sudo dnf update -y

# Need dev release for: OCI
# ALready installed with ol8 - leaving in for documenting that we need this
sudo dnf -y install oraclelinux-developer-release-el8
sudo dnf -y install python36-oci-cli

# Install GraalVM
sudo dnf config-manager --set-enabled ol8_codeready_builder
sudo yum install -y gcc glibc-devel zlib-devel
sudo yum -y install graalvm22-ee-17-native-image
echo "export JAVA_HOME=/usr/lib64/graalvm/graalvm22-ee-java17" >> ~/.bashrc
echo "export GRAALVM_HOME=\$JAVA_HOME" >> ~/.bashrc

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

# Install useful tools
# git
sudo yum install -y git

# jq
sudo yum install -y jq

# termgraph
sudo dnf -y module install python39
sudo alternatives --set python3 /usr/bin/python3.9
python -m ensurepip --upgrade
python -m pip install termgraph
/usr/bin/python -m pip install --upgrade pip

# curl, telnet, tar, gzip, wget
sudo yum install -y curl telnet tar gzip wget

# hey
curl https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 --output ~/bin/hey
sudo chown opc:opc bin/hey
sudo chmod u+x bin/hey

# mysql client
sudo yum -y install mysql

# mvn
# Install Maven
# Source:
# 1) https://github.com/carlossg/docker-maven/blob/925e49a1d0986070208e3c06a11c41f8f2cada82/openjdk-17/Dockerfile
# 2) https://maven.apache.org/download.cgi
export SHA=f790857f3b1f90ae8d16281f902c689e4f136ebe584aba45e4b1fa66c80cba826d3e0e52fdd04ed44b4c66f6d3fe3584a057c26dfcac544a60b301e6d0f91c26
export MAVEN_DOWNLOAD_URL=https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

sudo mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_DOWNLOAD_URL} \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && sudo tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && sudo ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

echo "export MAVEN_HOME=/usr/share/maven" >> ~/.bashrc
echo "export MAVEN_CONFIG='\$USER_HOME_DIR/.m2'" >> ~/.bashrc

# gradle
wget https://services.gradle.org/distributions/gradle-7.5-bin.zip
sudo mkdir /opt/gradle
sudo unzip -d /opt/gradle gradle-7.5-bin.zip
echo "export PATH=\$PATH:/opt/gradle/gradle-7.5/bin" >> ~/.bashrc
rm gradle-7.5-bin.zip

# envsubst
sudo yum install -y gettext

# docker
sudo yum remove docker \
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
sudo usermod -aG docker $USER
newgrp docker

# libmusl tool chain?
# Download musl
mkdir -p musl && cd musl
wget http://more.musl.cc/10/x86_64-linux-musl/x86_64-linux-musl-native.tgz
tar -xzf x86_64-linux-musl-native.tgz
rm x86_64-linux-musl-native.tgz
export TOOLCHAIN_DIR=`pwd`/x86_64-linux-musl-native
export CC=${TOOLCHAIN_DIR}/bin/gcc
# Download, build, install zlib into TOOLCHAIN_DIR
wget https://zlib.net/zlib-1.2.12.tar.gz
tar -xzf zlib-1.2.12.tar.gz
rm zlib-1.2.12.tar.gz
cd zlib-1.2.12
./configure --prefix=${TOOLCHAIN_DIR} --static
make
make install
cd ..
# Add TOOLCHAIN_DIR to PATH
# Add it to bash, but as a comment. If you add libmusl to the path,native image only works if you specify
# libmusl as the libc
# Currently, if you add libmusl to the path builds will fail, unless you explicitly specify using limbusl
echo "export LIBMUSL_BIN_DIR=${TOOLCHAIN_DIR}/bin" >> ~/.bashrc

# For manipulating the PATH variable
echo "path_append ()  { path_remove $1; export PATH="$PATH:$1"; }" >> ~/.bashrc
echo "path_prepend () { path_remove $1; export PATH="$1:$PATH"; }" >> ~/.bashrc
echo "path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }" >> ~/.bashrc

echo "# Adds LIBMUSL to path" >> ~/.bashrc
echo "libmusl_use() { path_prepend $LIBMUSL_BIN_DIR; }" >> ~/.bashrc
echo "libmusl_rm() { path_remove $LIBMUSL_BIN_DIR; }" >> ~/.bashrc
cd

# Install upx
sudo dnf install -y xz
wget https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz
tar -xf upx-3.96-amd64_linux.tar.xz --directory bin
rm upx-3.96-amd64_linux.tar.xz
cp bin/upx-3.96-amd64_linux/upx* bin
rm -rf bin/upx-3.96-amd64_linux/

#
# Image Cleanup for OCI Marketplace
#
cd /tmp
wget https://raw.githubusercontent.com/oracle/oci-utils/master/libexec/oci-image-cleanup -O /tmp/oci-image-cleanup.sh
chmod +x oci-image-cleanup.sh

cat > /tmp/cleanup.sh <<EOF
#!/bin/bash
systemctl stop rsyslog
sh -c 'yes| /tmp/oci-image-cleanup.sh'
sed -i -e 's|^.*PermitRootLogin.*\$|PermitRootLogin no|g' /etc/ssh/sshd_config
sed -i -e 's|root:x:0:0:root:/root:/bin/bash|root:x:0:0:root:/root:/sbin/nologin|g' /etc/passwd
ln -sf /root/bootstrap/firstboot.sh /var/lib/cloud/scripts/per-instance/firstboot.sh
ln -sf /root/bootstrap/eachboot.sh /var/lib/cloud/scripts/per-boot/eachboot.sh
rm -f /u01/app/osa/non-marketplace-init/system-configured
rm -rf /home/oracle/log/*
rm -rf /home/opc/log/*
rm -f /var/log/audit/audit.log
EOF
chmod +x /tmp/cleanup.sh
sudo /tmp/cleanup.sh

