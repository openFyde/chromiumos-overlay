# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="6052e8e9c902e797dbe87cc584d2cee3bd3e717d"
CROS_WORKON_TREE="08f1523d55beaa6a25bdd05ddc7265b488c11d41"
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

CHROMEOS_PROFILE="/usr/local/portage/chromiumos/profiles/targets/chromeos"

src_install() {
	# Install tools from platform/dev into /usr/local/bin
	into /usr/local
	dobin stateful_update

	insinto /usr/local/etc/portage/make.profile/
	newins "${FILESDIR}/parent" parent

	# Setup package.provided so that gmerge will know what packages to ignore.
	# - $CHROMEOS_PROFILE/package.provided contains packages that we don't
	#   want to install to the device.
	insinto /usr/local/etc/portage/make.profile/package.provided
	newins "${CHROMEOS_PROFILE}"/package.provided chromeos
}
