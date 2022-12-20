# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("b82f1afff1b508e4120790c70c8d2b2c57ebb5c3" "fcd3caa28765ee13fa7fdfa3f2f82d125f794c3d" "0665f0f3be05d84a747b0e1fccbae8a84c18cec6" "68b356f2e7a8c6103eff9662d1d37d52a0f49305")
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "ed64e808a1b6214878e2969dfa5d4bfc84ea67cd" "df5a1a35f1d076f3a5d85e911761163ed3b19d64" "c3473ab29243f136628d4c8708ab647c15f6a411")
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
