# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e1db85555d7b3e7eb8ed5e43ac7debd65215027d"
CROS_WORKON_TREE="6b952840e7470e61730c0e337da907d3a934b2a4"
CROS_WORKON_PROJECT="chromiumos/third_party/toolchain-utils"
CROS_WORKON_LOCALNAME="toolchain-utils"

inherit cros-workon

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/toolchain-utils/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-misc/pax-utils
	dev-lang/python
	sys-devel/binutils
"

src_install() {
	local tc_dir="/usr/$(get_libdir)/${PN}"
	local dit_dir="${tc_dir}/debug_info_test"

	insinto ${tc_dir}
	doins -r debug_info_test

	fperms a+x ${dit_dir}/debug_info_test.py

	dosym ${dit_dir}/debug_info_test.py /usr/bin/debug_info_test

	newbin afdo_redaction/redact_profile.py redact_textual_afdo_profile

	newbin afdo_redaction/remove_indirect_calls.py remove_indirect_calls

	newbin afdo_redaction/remove_cold_functions.py remove_cold_functions
}
