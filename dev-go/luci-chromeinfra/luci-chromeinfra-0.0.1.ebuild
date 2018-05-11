# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/luci-* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="chromium.googlesource.com/infra/luci/luci-go:go.chromium.org/luci 77b23ce4c9189484e14035690f439c97f7629c2e"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/hardcoded/chromeinfra"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="LUCI Go hardcoded chrome infra values library"
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/luci-auth
	dev-go/homedir
"
RDEPEND="${DEPEND}"
