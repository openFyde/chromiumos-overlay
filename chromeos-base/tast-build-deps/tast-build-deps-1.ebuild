# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Build-time dependencies of Tast binaries"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/aosp-frameworks-base-proto
	chromeos-base/policy-go-proto
	chromeos-base/system_api
	chromeos-base/vm_protos
	chromeos-base/wilco-dtc-grpc-protos
	dev-go/boringssl-acvptool
	dev-go/cdp
	dev-go/cmp
	dev-go/crypto
	dev-go/dbus
	dev-go/golint
	dev-go/gopsutil
	dev-go/go-matroska
	dev-go/grpc
	dev-go/mdns
	dev-go/protobuf
	dev-go/selinux
	dev-go/subcommands
	dev-go/sync
	dev-go/vsock
	dev-go/yaml
"

RDEPEND="${DEPEND}"
