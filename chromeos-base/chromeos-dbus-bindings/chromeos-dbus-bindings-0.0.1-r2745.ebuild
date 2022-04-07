# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="6589eccd5b550faac865c9f182f8c6b033ce0f84"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "f39bb7b1448bb1048c70a3345f254b7d44ef8cdc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
