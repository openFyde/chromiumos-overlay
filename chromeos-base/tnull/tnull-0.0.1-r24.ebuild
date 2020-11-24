# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="22acb0c88985f47bfe020e01f14362c53d8ae80e"
CROS_WORKON_TREE="e0ceab78107b3009d1a63dc88c36d0797002bff3"
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
