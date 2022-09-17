# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="922ce573f3afeb2b5c78ced7c7791ee8902273b6"
CROS_WORKON_TREE="d2e46dd8973e0eb53867c8285d2974b9f2f425a7"
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
