#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2025-2026 The Secureblue Authors
#
# SPDX-License-Identifier: Apache-2.0

# Package dependencies for this script:
# git-core go2rpm go-vendor-tools python3-specfile rpmautospec rpmdevtools

set -eux

git clone https://github.com/secureblue/crane.git
VERSION=$(grep -oP -m1 '^Version:\s+\K\S+' crane/crane.spec)
(
    cd crane
    cp go-vendor-tools.toml ..
    rpmautospec process-distgit ./crane.spec ../crane.spec
)
mkdir -p generate_vendor
cp go-vendor-tools.toml generate_vendor
(
    cd generate_vendor
    go2rpm --name crane --profile vendor --version "${VERSION}" -s pkg/crane https://github.com/google/go-containerregistry/
    mv "go-containerregistry-${VERSION}.tar.gz" "go-containerregistry-${VERSION}-vendor.tar.bz2" ..
)
rm -rf crane generate_vendor
