# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ee9fd10f1475cf7db8882404068e938b4846f36d"
CROS_WORKON_TREE=("0a34e7c8254674b933abb878c9bc51424fdecd10" "26ab03ca281ea04da7238df964f7f2d8b07c3886" "49ef6eb50cab6bbcda37cd713ebe0c04e1079ae3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk libec rgbkbd .gn"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="rgbkbd"

inherit cros-workon platform tmpfiles user udev

DESCRIPTION="A daemon for controlling an RGB backlit keyboard."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/rgbkbd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	chromeos-base/libec:=
	chromeos-base/system_api:=
"

pkg_preinst() {
	# Ensure that this group exists so that rgbkbd can access /dev/cros_ec.
	enewgroup "cros_ec-access"
	# Create user and group for RGBKBD.
	enewuser "rgbkbd"
	enewgroup "rgbkbd"
}

src_install() {
	platform_src_install

	# Create tmpfiles for testing.
	dotmpfiles tmpfiles.d/rgbkbd.conf

	udev_dorules udev/*.rules

	if use fuzzer; then
		local fuzzer_component_id="1131926"
		platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/rgb_daemon_fuzzer \
			--comp "${fuzzer_component_id}"
	fi
}

platform_pkg_test() {
	platform test_all
}
