# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="e0d0d33ea648feba145c8483ece317b6845a074d"
CROS_WORKON_TREE=("56c75aa73108d344f9441f26855f37e4c4838dd3" "3848ec8f04ff204bcd74225f597250e76660006a")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk oobe_config"

PLATFORM_SUBDIR="oobe_config"

inherit cros-workon platform user

DESCRIPTION="Provides utilities to save and restore OOBE config."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/oobe_config/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	sys-apps/dbus
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
"

pkg_preinst() {
	enewuser "oobe_config_save"
	enewuser "oobe_config_restore"
	enewgroup "oobe_config_save"
	enewgroup "oobe_config_restore"
}

src_install() {
	dosbin "${OUT}"/oobe_config_save
	dosbin "${OUT}"/oobe_config_restore
	dosbin "${OUT}"/finish_oobe_auto_config

	# TODO(zentaro): Add secomp filters once implemented.
}

platform_pkg_test() {
	local tests=(
		oobe_config_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
