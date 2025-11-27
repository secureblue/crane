#! /bin/bash -x

# Copyright 2025 The Trivalent Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

set -oue pipefail

cd crane
VERSION=$(grep -E '^Version:' crane.spec | awk '{print $2}')
mkdir -p generate_vendor
cp go-vendor-tools.toml generate_vendor
cd generate_vendor
go2rpm --name crane --profile vendor --version "${VERSION}" -s pkg/crane https://github.com/google/go-containerregistry/
mv "go-containerregistry-${VERSION}-vendor.tar.bz2" ..
cd ..
rm generate_vendor -rf
cd ..
