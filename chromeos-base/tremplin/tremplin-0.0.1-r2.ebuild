# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="28c3cac04829bce27d9d8b1d07bba3807bc665c3"
CROS_WORKON_TREE="ed3cfa28d1bb62b1de5c75aa4d49e6d9efff6d27"
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
	dev-go/grpc
"

RDEPEND="app-emulation/lxd"
