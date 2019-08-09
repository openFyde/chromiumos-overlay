# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="f3846d31c612e4941be63f0441cc7a852b39efdc"
CROS_WORKON_TREE="9968f71551a6b198d40937fa4072de521f611500"
CROS_WORKON_PROJECT="chromiumos/platform/tremplin"
CROS_WORKON_LOCALNAME="tremplin"
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
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	app-emulation/lxd
	chromeos-base/vm_guest_tools
	chromeos-base/vm_protos
	dev-go/go-libaudit
	dev-go/go-sys
	dev-go/grpc
	dev-go/kobject
	dev-go/netlink
	dev-go/vsock
	dev-go/yaml
"

RDEPEND="app-emulation/lxd"
