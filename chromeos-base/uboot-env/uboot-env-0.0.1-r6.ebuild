# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_COMMIT="ab10366ee27959666b94a638858032c91c3c5e10"
CROS_WORKON_TREE="474379b7bfb64818594de559803564c6dd441a08"
CROS_WORKON_PROJECT="chromiumos/platform/uboot-env"

inherit cros-workon

DESCRIPTION="Python script to read/write u-boot environment"
SLOT="0"
KEYWORDS="arm x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${S}/uboot-env.py || die
}
