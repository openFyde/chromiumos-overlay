# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f8a47829e44890754dcd0c6255f4d0e3c51d1cd5"
CROS_WORKON_TREE="dafe4ad3a13bac9e0835d18f864a844fd4804725"
CROS_WORKON_PROJECT="chromiumos/platform/tremplin"
CROS_WORKON_LOCALNAME="platform/tremplin"
CROS_GO_BINARIES="chromiumos/tremplin"

CROS_GO_TEST=(
	"chromiumos/tremplin/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-workon cros-go

DESCRIPTION="Tremplin LXD client with gRPC support"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tremplin/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	app-emulation/lxd:0
	app-emulation/lxd:4
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/vm_guest_tools:=
	chromeos-base/vm_protos:=
	dev-go/go-libaudit:=
	dev-go/go-sys:=
	dev-go/grpc:=
	dev-go/kobject:=
	dev-go/netlink:=
	dev-go/vsock:=
	dev-go/yaml:=
"

RDEPEND="${COMMON_DEPEND}"
