# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f01e7311c0d7223503d7f4c1b6f5e0a513ad65e9"
CROS_WORKON_TREE="d9ba54b2d1cadcdacad882d90fd2e30922ea6c58"
CROS_WORKON_PROJECT="chromiumos/platform/tast"
CROS_WORKON_LOCALNAME="platform/tast"

inherit cros-go cros-workon

CROS_GO_VERSION="${PF}"

CROS_GO_PACKAGES=(
	"chromiumos/tast/framework/protocol/..."
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

DESCRIPTION="Provides go bindings to proto APIs for tast"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/cros-config-api
	dev-go/protobuf-legacy-api
	dev-go/text
"

RDEPEND=""

src_install() {
	insinto /usr/lib/gopath/src/
	cros-go_src_install
}
