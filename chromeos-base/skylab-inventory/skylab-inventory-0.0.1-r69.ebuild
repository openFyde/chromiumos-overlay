# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="b8cad5d99520a59747590cc8fff023d0546a3868"
CROS_WORKON_TREE="b8e888eb3aee8ac8762b37b1eacdf66ae925130b"
CROS_WORKON_PROJECT="chromiumos/infra/skylab_inventory"
CROS_WORKON_LOCALNAME="../../infra/skylab_inventory"
CROS_GO_WORKSPACE="${S}/go"

CROS_GO_BINARIES=(
	"skyinv/cmd/skylab-inventory-servers"
	"skyinv/cmd/skylab-inventory-mon"
)

CROS_GO_PACKAGES=(
	"chromiumos/infra/skylab/inventory"
	"chromiumos/infra/skylab/inventory/protos"
)

inherit cros-workon cros-go

DESCRIPTION="Chromium OS inventory tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/infra/skylab_inventory/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/errors:=
	dev-go/go-sys:=
	dev-go/luci-tsmon:=
	dev-go/protobuf:=
"
RDEPEND="${DEPEND}"
