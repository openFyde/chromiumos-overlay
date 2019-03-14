# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="a02cc337a6cc9d11f9c4d1cc34e17e637a57f48f"
CROS_WORKON_TREE="a7054021f1976533096a10b32b8b2e4217a1d66b"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_SUBTREE="stateful_update"

inherit cros-workon

DESCRIPTION="A util for installing packages using the CrOS dev server"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-arch/tar
	dev-util/shflags
	net-misc/curl"

# Nothing to compile.
src_compile() { :; }

src_install() {
	# Install tools from platform/dev into /usr/local/bin
	into /usr/local
	dobin stateful_update
}
