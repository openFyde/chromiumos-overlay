# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b9eca7a2bc8d57ed0722d2e7a95787fc5ac9d4e3"
CROS_WORKON_TREE=("dd5deba53d49ed330f1ab8e59f845daae76650c8" "e724db1a07dc4ca61ca9add613693e96c3b833b3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/modemfwd/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
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
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	cros-go_src_install
}
