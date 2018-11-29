# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="03711a26cb816b03fbd544c771e4655952855167"
CROS_WORKON_TREE="1f2e50c440e0d3627cbfc6b935215ebdfe525fe9"
CROS_WORKON_PROJECT="chromiumos/platform/tremplin"
CROS_WORKON_LOCALNAME="tremplin"
CROS_GO_BINARIES="chromiumos/tremplin"

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
	dev-go/grpc
	dev-go/vsock
"

RDEPEND="app-emulation/lxd"
