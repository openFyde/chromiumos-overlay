# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4f56756dda149f1cb6d89687d1395b59edd31a06"
CROS_WORKON_TREE="bdaaeb8e3ef5b935ac3cdfa1d4f6d1446c8ec0df"
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
