# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("2d9622a624880d0b83b1ccfa21d83fc66c0e1a39" "99cf891427be5a674d8536a74140537444da1812" "c2d30b8e2ec9ba5f2b14c4d8db0ac89531df8ab8" "a7d6a7cd435acb9fd405f96b83ff5e43f8cc966f")
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "17fb58cb5f39bae71eaa86861a4cccc561b0fd1c" "4f7e4e12e269fc21ec3e76a9ac1441723c99ef2b" "e65e1a07161a4bd8d6aef57c91726d815fff444f")
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
	chromeos-base/libchrome
	dev-libs/flatbuffers
"
RDEPEND="${DEPEND}"

src_configure() {
	ARCH="$(tc-arch "${CBUILD}")" tc-env_build platform "configure" "--host"
}

src_compile() {
	ARCH="$(tc-arch "${CBUILD}")" tc-env_build platform "compile" "tools" "--host"
}

src_install() {
	platform_src_install

	local bin_dir="$(cros-workon_get_build_dir)/out/Default/"
	dobin "${bin_dir}/bluetooth_packetgen"
	dobin "${bin_dir}/bluetooth_flatbuffer_bundler"
}
