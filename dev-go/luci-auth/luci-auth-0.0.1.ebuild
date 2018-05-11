# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/luci-* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="chromium.googlesource.com/infra/luci/luci-go:go.chromium.org/luci 77b23ce4c9189484e14035690f439c97f7629c2e"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/auth"
	"go.chromium.org/luci/auth/internal"
	"go.chromium.org/luci/auth/integration/localauth/rpcs"
)

inherit cros-go

DESCRIPTION="LUCI Go auth library"
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
# Tests import "github.com/smartystreets/goconvey/convey", which we don't have.
RESTRICT="binchecks test strip"

DEPEND="
	dev-go/gcp-compute
	dev-go/grpc
	dev-go/luci-common
	dev-go/net
	dev-go/oauth2
"
RDEPEND="${DEPEND}"
