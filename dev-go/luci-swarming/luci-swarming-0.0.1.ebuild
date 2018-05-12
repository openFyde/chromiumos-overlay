# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# Disable cros-workon auto-uprev since this is an external package.
# Must manage commit hash manually.
CROS_WORKON_BLACKLIST="1"
CROS_WORKON_COMMIT="77b23ce4c9189484e14035690f439c97f7629c2e"
CROS_WORKON_PROJECT="infra/luci/luci-go"
CROS_WORKON_DESTDIR="${S}/src/go.chromium.org/luci"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/common/api/swarming/swarming/v1"
)

inherit cros-workon cros-go

DESCRIPTION="LUCI Go swarming API library"
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
# Tests import "github.com/smartystreets/goconvey/convey", which we don't have.
RESTRICT="binchecks test strip"

DEPEND="
	dev-go/gapi-gensupport
	dev-go/gapi-googleapi
	dev-go/net
"
RDEPEND="${DEPEND}"
