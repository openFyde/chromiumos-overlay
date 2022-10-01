# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0f8d39dfd529473903c1dc6b0561b7abbfbb7147"
CROS_WORKON_TREE="759045ddd4ce5da46c32bcc4fe32ca1aae9ea9d2"
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
