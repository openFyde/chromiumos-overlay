# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="06a63577baee7a9f3d4cba5ccd12bbc552aff59f"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "a61e5ab10dbcef3d291a4ccb8b33fc4beab47136" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_GO_PACKAGES=(
	"chromiumos/reporting/..."
	"chromiumos/xdr/reporting/..."
)

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk missive .gn"

PLATFORM_SUBDIR="missive/proto"

inherit cros-workon cros-go platform

DESCRIPTION="reporting/missive go protos for ChromeOS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/missive"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	dev-libs/protobuf:=
"

DEPEND="
	${RDEPEND}
	dev-go/protobuf
	dev-go/protobuf-legacy-api
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	cros-go_src_install
}
