# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="a02cc337a6cc9d11f9c4d1cc34e17e637a57f48f"
CROS_WORKON_TREE="bc1af6dd00aa3a10037b05eaf4b19a2f59280543"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"

inherit cros-workon

DESCRIPTION="A util for installing packages using the CrOS dev server"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-arch/tar
	dev-util/shflags
	net-misc/curl"

src_install() {
	# Install tools from platform/dev into /usr/local/bin
	into /usr/local
	dobin stateful_update
}
