# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="36aed02287a4bdf1a99340f77bf00891c7d5a551"
CROS_WORKON_TREE=("0d8a167e372a74ff40cff24fdc7d47644590bb7e" "f9559bb24ca0c0f08cfd600f978e909fd34f8d4e" "5b75188213f24484dc9fae5df56f8c6e5563c509" "12457839992654654c3e961b437effcbfd494567" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
