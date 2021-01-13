# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="2cf5acacb50c80ac39a71a770b5485d6f3406add"
CROS_WORKON_TREE="67fb9d97d72f12314c83ad088c4829ff915db0b8"
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
