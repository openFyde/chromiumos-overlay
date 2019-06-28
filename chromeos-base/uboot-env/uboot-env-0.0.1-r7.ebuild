# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_COMMIT="5ad506f38e25df5361f1ec7892e9b4f201590a64"
CROS_WORKON_TREE="33477d293e0a2890260c8fc617091a804f60a94c"
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
