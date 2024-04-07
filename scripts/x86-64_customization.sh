#!/bin/bash

set -ex

# crypto
echo '
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305_X86_64=y
' >> ./target/linux/x86/64/config-6.1

source ./01_customize_packages.sh

# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

exit 0
