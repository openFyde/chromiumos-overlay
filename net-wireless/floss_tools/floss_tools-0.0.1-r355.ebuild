# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("f643cf8f485a5380b18b0c3a3d24f39ddfb1bb63" "5910a05c6efaa6a9cce519dea8740de3584dbbde" "3db65fd21b0db4541931c62b68834439178ad65d" "68b356f2e7a8c6103eff9662d1d37d52a0f49305")
CROS_WORKON_TREE=("e9b5125e1997da827cca1bbd3b21829a4037c402" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "726981181408f1ee3497608b0f8638126602c707" "b00b7b68e8d9e6b718de38f73db42aa13216e0dd" "c3473ab29243f136628d4c8708ab647c15f6a411")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/packages/modules/Bluetooth"
	"aosp/platform/packages/modules/Bluetooth"
	"aosp/platform/frameworks/proto_logging"
)
CROS_WORKON_LOCALNAME=(
	"../platform2"
	"../aosp/packages/modules/Bluetooth/local"
	"../aosp/packages/modules/Bluetooth/upstream"
	"../aosp/frameworks/proto_logging"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/bt"
	"${S}/platform2/bt"
	"${S}/platform2/external/proto_logging"
)
CROS_WORKON_SUBTREE=("common-mk .gn" "" "" "")
CROS_WORKON_EGIT_BRANCH=("main" "main" "upstream/master" "master")
CROS_WORKON_OPTIONAL_CHECKOUT=(
	""
	"use !floss_upstream"
	"use floss_upstream"
	""
)
PLATFORM_SUBDIR="bt"

IUSE="floss_upstream"

WANT_LIBCHROME="no"
WANT_LIBBRILLO="no"
inherit cros-workon toolchain-funcs platform

DESCRIPTION="Bluetooth Build Tools"
HOMEPAGE="https://android.googlesource.com/platform/packages/modules/Bluetooth"

# Apache-2.0 for system/bt
# All others from rust crates
LICENSE="
	Apache-2.0
	MIT BSD ISC
"
KEYWORDS="*"

DEPEND=""
BDEPEND="
	dev-libs/tinyxml2
"
RDEPEND="${DEPEND}"

src_configure() {
	ARCH="$(tc-arch "${CBUILD}")" tc-env_build platform "configure" "--host"
}

src_compile() {
	ARCH="$(tc-arch "${CBUILD}")" tc-env_build platform "compile" "tools" "--host"
}

src_install() {
	local bin_dir="$(cros-workon_get_build_dir)/out/Default/"
	dobin "${bin_dir}/bluetooth_packetgen"
	dobin "${bin_dir}/bluetooth_flatbuffer_bundler"
}
