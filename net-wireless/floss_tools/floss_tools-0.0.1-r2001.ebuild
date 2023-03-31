# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("e364b159e56f23ece2af994214187c650908d14f" "a20e0e03c81be9db4ac567e7008c02c4952cda7f" "53cdc5f602fea3b7646474336096aac85557fa03" "a7d6a7cd435acb9fd405f96b83ff5e43f8cc966f")
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "61a20eebaebfd2b82572067a52ca317dc4e85910" "7b77d382dddb8b247de57594fa6bd2781a64397e" "e65e1a07161a4bd8d6aef57c91726d815fff444f")
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
