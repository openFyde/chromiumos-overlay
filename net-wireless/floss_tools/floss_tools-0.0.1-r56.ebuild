# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("49f3fd23e7daacd59aa92dfa563a5a9e59e4577e" "2175e915c0a513511e65808160180ccd60a3c7f7" "a17c2269cdeac19decb991e6691ee4e62c774db1" "68b356f2e7a8c6103eff9662d1d37d52a0f49305")
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7d95f2dea791518b12532be2b19275fe4638b444" "796d1603787a6c1075d7bda325cba3959656b702" "c3473ab29243f136628d4c8708ab647c15f6a411")
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
BDEPEND=""
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
