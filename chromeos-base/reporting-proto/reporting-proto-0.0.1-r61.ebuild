# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c526f9b1def0ee2d2066e84e5f3a573422e13796"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "3f85cd9e18d327a05e651e6f1280fe9ce570a2ee" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
