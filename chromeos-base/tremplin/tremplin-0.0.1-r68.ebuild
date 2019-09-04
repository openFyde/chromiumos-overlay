# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="022c0eeabffaaf8c993b69e7595ee50249859038"
CROS_WORKON_TREE="27699c397c393c0dbe0e77a6642ae84152578845"
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
