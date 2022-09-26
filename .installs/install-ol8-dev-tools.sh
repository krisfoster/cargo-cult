#!/usr/bin/env bash
#
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# The Universal Permissive License (UPL), Version 1.0
#
# Subject to the condition set forth below, permission is hereby granted to any
# person obtaining a copy of this software, associated documentation and/or
# data (collectively the "Software"), free of charge and under any and all
# copyright rights in the Software, and any and all patent rights owned or
# freely licensable by each licensor hereunder covering either (i) the
# unmodified Software as contributed to or provided by such licensor, or (ii)
# the Larger Works (as defined below), to deal in both
#
# (a) the Software, and
#
# (b) any piece of software and/or hardware listed in the lrgrwrks.txt file if
# one is included with the Software each a "Larger Work" to which the Software
# is contributed by such licensors),
#
# without restriction, including without limitation the rights to copy, create
# derivative works of, display, perform, and distribute the Software and make,
# use, sell, offer for sale, import, export, have made, and have sold the
# Software and the Larger Work(s), and to sublicense the foregoing rights on
# either these or other terms.
#
# This license is subject to the following condition:
#
# The above copyright notice and either this complete permission notice or at a
# minimum a reference to the UPL must be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
set -o errexit # fail on error
set -o nounset # fail if a variable is undefined

readonly SETUP_SCRIPT_VERSION="1.0.0"
readonly HEY_DOWNLOAD_URL="https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64"
readonly PYTHON_PACKAGE="python39"
readonly PYTHON_VERSION="3.9"
readonly UPX_DOWNLOAD_URL="https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz"
readonly UPX_VERSION=""


echo "OCI OL8 Dev Tools Script: VERSION ${SETUP_SCRIPT_VERSION}"

# Check for Oracle Linux 8
if [ "ol8" == `cat /etc/oracle-release | sed -E 's|Oracle Linux Server release 8\..+|ol8|'` ]; then
  echo -e "\e[32mSystem is Oracle Linux 8\e[0m"
else
  echo -e "\e[31mSystem is NOT Oracle Linux 8\e[0m"
  echo -e "\e[31mThis install script is only meant to run with Oracle Linnux 8\e[0m"
  exit 1
fi

# Install useful tools
# git, jq, telnet, tar, gzip, wget, envsubst
sudo yum install -y git jq telnet tar gzip wget gettext

# hey
curl ${HEY_DOWNLOAD_URL} --output ~/bin/hey
sudo chown opc:opc bin/hey
sudo chmod u+x bin/hey

# termgraph
sudo dnf -y module install ${PYTHON_PACKAGE}
sudo alternatives --set python3 /usr/bin/python${PYTHON_VERSION}
python -m ensurepip --upgrade
python -m pip install termgraph
/usr/bin/python -m pip install --upgrade pip

# Install upx
sudo dnf install -y xz
wget ${UPX_DOWNLOAD_URL}
tar -xf upx-${UPX_VERSION}-amd64_linux.tar.xz --directory bin
rm upx-${UPX_VERSION}-amd64_linux.tar.xz
cp bin/upx-${UPX_VERSION}-amd64_linux/upx* bin
rm -rf bin/upx-${UPX_VERSION}-amd64_linux/