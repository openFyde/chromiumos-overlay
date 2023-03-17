# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb9afe6773e6b4e0927003b9b85087f875eef03e"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "a3985094f75943a6cff1de294d3f64e33e77f865" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_GO_PACKAGES=(
	"chromiumos/reporting/..."
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
	platform_src_install

	cros-go_src_install
}
