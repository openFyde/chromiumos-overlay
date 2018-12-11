# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="5192d7f28c96bfa03741b787e70ba996a9735190"
CROS_WORKON_TREE="dbed567d687b49b6b87e83511c0471c9d5db6b34"
CROS_WORKON_PROJECT="chromiumos/third_party/toolchain-utils"
CROS_WORKON_LOCALNAME="toolchain-utils"

inherit cros-workon

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-misc/pax-utils
	dev-lang/python
	sys-devel/binutils
"

install_driven_test() {
	local tc_dir=$1
	local test_dir=$2
	local driver_script=$3

	insinto "${tc_dir}"
	doins -r "${test_dir}"

	local dit_dir="${tc_dir}/${test_dir}"

	fperms a+x "${dit_dir}/${driver_script}"

	# Remove the directory and file extension.
	local driver_base="$(basename "${driver_script}" | sed -E 's|\.[^.]+$||')"
	dosym "${dit_dir}/${driver_script}" "/usr/bin/${driver_base}"
}

src_install() {
	local tc_dir="/usr/$(get_libdir)/${PN}"
	install_driven_test "${tc_dir}" "afdo_redaction" "redact_profile_test.py"
	install_driven_test "${tc_dir}" "debug_info_test" "debug_info_test.py"
}
