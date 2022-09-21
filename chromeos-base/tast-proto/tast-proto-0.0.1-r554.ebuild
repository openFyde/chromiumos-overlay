# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="26ebdbf73e9add5f7824f56f2238572f6a1e2ba5"
CROS_WORKON_TREE="6af72c1ceb8c3e42e6f2931552445cc39b926a26"
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
	dev-go/protobuf-legacy-api
	dev-go/text
"

RDEPEND=""

src_install() {
	insinto /usr/lib/gopath/src/
	cros-go_src_install
}
