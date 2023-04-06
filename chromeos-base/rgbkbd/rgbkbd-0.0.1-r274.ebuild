# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="33a8fa386180a5fce9d1ab59a0d2e9a18521f378"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "d031af9b5360ae0f704f4d6ef23b234fc46152cf" "b6b60e8b2bf4c872feb68e370aee5d361daf9b7c" "a66ee8476dbeb842f01a37a2f800e3faee4ae474" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk chromeos-config libec rgbkbd .gn"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="rgbkbd"

inherit cros-workon cros-unibuild platform tmpfiles user udev

DESCRIPTION="A daemon for controlling an RGB backlit keyboard."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/rgbkbd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config-tools:=
	chromeos-base/libbrillo:=
	chromeos-base/libec:=
	chromeos-base/system_api:=
	virtual/udev
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
