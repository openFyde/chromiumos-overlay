# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="d15d035c7340892725648f6fd9b97a82b21b3fc8"
CROS_WORKON_TREE=("8ff1eab586712c03641dda82a1877dfc4cd6eb72" "0b8641c250b5565b30f3c49417653ba6397c36a6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-dbus-bindings .gn"

PLATFORM_SUBDIR="${PN}"
PLATFORM_NATIVE_TEST="yes"

inherit cros-go cros-workon platform

DESCRIPTION="Utility for building Chrome D-Bus bindings from an XML description"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-dbus-bindings"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

CROS_GO_BINARIES=(
	"chromiumos/dbusbindings/cmd/generator:/usr/bin/go-generate-chromeos-dbus-bindings"
)

RDEPEND="
	dev-libs/expat
	sys-apps/dbus"
DEPEND="${RDEPEND}"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${S}/go"
}

src_compile() {
	cros-go_src_compile
	platform_src_compile
}

src_install() {
	cros-go_src_install

	dobin "${OUT}"/generate-chromeos-dbus-bindings

	local fuzzer_component_id="931982"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/chromeos_dbus_bindings_signature_fuzzer \
			--comp "${fuzzer_component_id}"
}

src_test() {
	platform_test "run" "${OUT}/chromeos_dbus_bindings_unittest"
	cros-go_src_test
}
