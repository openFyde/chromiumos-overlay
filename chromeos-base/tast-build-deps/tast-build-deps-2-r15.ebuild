# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_COMMIT="e8d0ce9c4326f0e57235f1acead1fcbc1ba2d0b9"
CROS_WORKON_TREE="f365214c3256d3259d78a5f4516923c79940b702"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon

DESCRIPTION="Build-time dependencies of Tast binaries"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/aosp-frameworks-base-proto
	chromeos-base/cros-config-api
	chromeos-base/hardware_verifier_proto
	chromeos-base/modemfwd-proto
	chromeos-base/policy-go-proto
	chromeos-base/system_api
	chromeos-base/vm_protos
	chromeos-base/wilco-dtc-grpc-protos
	dev-go/boringssl-acvptool
	dev-go/cdp
	dev-go/clock
	dev-go/cmp
	dev-go/crypto
	dev-go/dbus
	dev-go/docker
	dev-go/dst
	dev-go/exif
	dev-go/fscrypt
	dev-go/gapi-drive
	dev-go/genproto
	dev-go/godebug
	dev-go/golang-evdev
	dev-go/golint
	dev-go/gopacket
	dev-go/gopsutil
	dev-go/go-matroska
	dev-go/go-sys
	dev-go/grpc
	dev-go/mdns
	dev-go/mock
	dev-go/mp4
	dev-go/oauth2
	dev-go/perfetto-protos
	dev-go/protobuf
	dev-go/selinux
	dev-go/subcommands
	dev-go/sync
	dev-go/tarm-serial
	dev-go/uuid
	dev-go/vnc2video
	dev-go/vsock
	dev-go/yaml
"

RDEPEND="${DEPEND}"
