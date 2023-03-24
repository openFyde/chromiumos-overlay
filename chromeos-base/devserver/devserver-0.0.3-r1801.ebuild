# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2c33b87ed9855e8f6d13e2af02c57bb4a0b5baa0"
CROS_WORKON_TREE="0264a4eb087e832b5f2946da8c7ebb27e4d901e1"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon

DESCRIPTION="Server to cache Chromium OS build artifacts from Google Storage."
HOMEPAGE="http://dev.chromium.org/chromium-os/how-tos-and-troubleshooting/using-the-dev-server"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	dev-lang/python
	dev-python/protobuf-python
	dev-python/cherrypy
	net-misc/gsutil
	!<chromeos-base/cros-devutils-1
"
DEPEND="
	dev-python/psutil
"

src_install() {
	emake install DESTDIR="${D}"
}

src_test() {
	# Run the unit tests.
	./run_unittests || die
}
