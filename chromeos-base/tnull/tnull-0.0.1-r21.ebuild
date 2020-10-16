# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b70aa90ae28c9504fecce4f3962ba641f3c79e0d"
CROS_WORKON_TREE="673fcd6ab0c0f30a48d1412cf07370ccf64c7370"
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
