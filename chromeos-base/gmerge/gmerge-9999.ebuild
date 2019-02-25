# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"

inherit cros-workon

DESCRIPTION="A util for installing packages using the CrOS dev server"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="app-arch/tar
	dev-util/shflags
	net-misc/curl"

src_install() {
	# Install tools from platform/dev into /usr/local/bin
	into /usr/local
	dobin stateful_update
}
