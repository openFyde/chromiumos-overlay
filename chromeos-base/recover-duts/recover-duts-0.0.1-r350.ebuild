# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="46e9461f0e01ce04f95f957b40c5ae7d4c0d6c60"
CROS_WORKON_TREE="012e01a7fe3e24a1cea1974d59f971bdff046fd5"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="crostestutils"

inherit cros-workon

DESCRIPTION="Test tool that recovers bricked Chromium OS test devices"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
!<chromeos-base/shill-0.0.4
chromeos-base/chromeos-init
dev-lang/python
"

# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

# Use default src_compile and src_install which use Makefile.

src_install() {
	pushd "${S}/recover_duts" || die
	newbin recover_duts.sh recover_duts
	dosbin reload_network_device

	pushd "hooks" || die
	dodir /usr/bin/hooks
	exeinto /usr/bin/hooks
	doexe *
	popd
}
