# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="096bf757f3a6245e4b7b4933ac346b7c6a6bf37e"
CROS_WORKON_TREE="3cf71f04c046fdf11f35c57d3d3c68824229c331"
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
	app-emulation/lxd:=
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
