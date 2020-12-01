# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2d3c7161702cbf079f310d734cb02119dcd55d09"
CROS_WORKON_TREE="5c4a1bc46fdccec73856971a9e613d4386e4e713"
CROS_WORKON_PROJECT="chromiumos/infra/tnull"
CROS_WORKON_LOCALNAME="../infra/tnull"

CROS_GO_BINARIES=(
	"tnull"
)

CROS_GO_VERSION="${PF}"

inherit cros-go cros-workon

DESCRIPTION="Remote Test Driver minimal/fake implementation"
HOMEPAGE="https://chromium.googlesource.com/${CROS_WORKON_PROJECT}"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/cros-config-api:=
	dev-go/luci-chromeinfra:=
	dev-go/luci-auth:=
	dev-go/luci-common:=
"

src_configure() {
	$(cros-workon_get_build_dir)/generate_metadata.sh
}
