# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="072788744b87122754a7ed225d019686970a340d"
CROS_WORKON_TREE=("e8200272d6283e7db5bd02f4007275ee41126c5a" "9c1b4e2e5a181d1dea45361f61732bfb5aba00ec" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/modemfwd/..."
)

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk modemfwd .gn"

PLATFORM_SUBDIR="modemfwd/proto"

inherit cros-workon cros-go platform

DESCRIPTION="modemfwd go proto for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/modemfwd"

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
