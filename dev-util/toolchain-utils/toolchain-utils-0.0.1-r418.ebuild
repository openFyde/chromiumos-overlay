# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3a13817c72c02e9c93964d0a1ef8fbc2ca1ba231"
CROS_WORKON_TREE="c28433310682d38223fd8e91608c8fa820933611"
CROS_WORKON_PROJECT="chromiumos/third_party/toolchain-utils"
CROS_WORKON_LOCALNAME="toolchain-utils"

inherit cros-workon

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="http://www.chromium.org/"

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
}
