# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d13a1beb844955af939956534c20e52ccbd19d5d"
CROS_WORKON_TREE="b33c92581190a31e01c9081e947316500fc70675"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon

DESCRIPTION="Server to cache Chromium OS build artifacts from Google Storage."
HOMEPAGE="http://dev.chromium.org/chromium-os/how-tos-and-troubleshooting/using-the-dev-server"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="!<chromeos-base/cros-devutils-0.0.4
	chromeos-base/devserver-deps
"
DEPEND="
	dev-python/psutil
"

src_install() {
	emake install DESTDIR="${D}"

	dobin host/start_devserver

	dosym /build /var/lib/devserver/static/pkgroot
	dosym /var/lib/devserver/static /usr/lib/devserver/static

	# Install Mob* Monitor checkfiles for the devserver.
	insinto "/etc/mobmonitor/checkfiles/devserver/"
	doins -r "${S}/checkfiles/devserver/"*
}

src_test() {
	# Run the unit tests.
	./run_unittests || die
}
