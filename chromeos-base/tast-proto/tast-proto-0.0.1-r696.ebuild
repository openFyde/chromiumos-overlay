# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="99b5f9ca8e3bfc9a70eb1f6c229f57f8bbcd4c10"
CROS_WORKON_TREE="965b8a4c3bbc68b9419a631e9bcaea757b49432b"
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
