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

#
# Variables
#
readonly GRAALVM_DOWNLOAD_URL="https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/22.3.0-dev-20220915_2039/graalvm-ce-java19-linux-amd64-dev.tar.gz"
readonly GRAALVM_TAR_FILE="graalvm-ce-java19-linux-amd64-dev.tar.gz"
readonly GRAALVM_VERSION_RELEASE="22.3.0-dev"
readonly GRAALVM_VERSION="graalvm-ce-java19"
readonly GRAAL_INSTALL_PATH="/usr/lib64/graalvm/${GRAALVM_VERSION}"
readonly SETUP_SCRIPT_VERSION="1.0.0"

echo "OCI OL8 GraalVM CE JDK19 **DEV** Install Script: VERSION ${SETUP_SCRIPT_VERSION}"

curl -sL ${GRAALVM_DOWNLOAD_URL} --output ${GRAALVM_TAR_FILE}

tar zxf ${GRAALVM_TAR_FILE}
sudo mv ./${GRAALVM_VERSION}-${GRAALVM_VERSION_RELEASE}  /usr/lib64/graalvm/${GRAALVM_VERSION}
sudo chown -R root:root /usr/lib64/graalvm/${GRAALVM_VERSION}
GRAALVM_CE_JDK19_HOME=/usr/lib64/graalvm/${GRAALVM_VERSION}
GRAALVM_CE_JDK19_BIN=/usr/lib64/graalvm/${GRAALVM_VERSION}


# For manipulating the PATH variable
echo "path_append ()  { path_remove $1; export PATH="$PATH:$1"; }" >> ~/.bashrc
echo "path_prepend () { path_remove $1; export PATH="$1:$PATH"; }" >> ~/.bashrc
echo "path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }" >> ~/.bashrc

# Save the old JAVA_HOME and GRAALVM_HOME vars
export OLD_JAVA_HOME=${JAVA_HOME}
export OLD_GRAALVM_HOME=${GRAALVM_HOME}
echo "# Save any old values of JAVA_HOME" >> ${HOME}/.bashrc
echo "export OLD_JAVA_HOME=${JAVA_HOME}" >> ${HOME}/.bashrc
echo "export OLD_GRAALVM_HOME=${OLD_GRAALVM_HOME}" >> ${HOME}/.bashrc

echo "# Adds JDK19 CE to path" >> ${HOME}/.bashrc
echo "jdk19_dev_use() { path_prepend $GRAALVM_CE_JDK19_BIN; export JAVA_HOME=$GRAALVM_CE_JDK19_HOME; export GRAALVM_HOME=$GRAALVM_CE_JDK19_HOME; }" >> ~/.bashrc
echo "jdk19_dev_rm() { path_remove $GRAALVM_CE_JDK19_BIN; export JAVA_HOME=$OLD_JAVA_HOME; export GRAALVM_HOME=$OLD_GRAALVM_HOME; }" >> ~/.bashrc

