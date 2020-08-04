# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="36914410572b3f1e0f234b4fb2afdd125d851ae8"
CROS_WORKON_TREE="45e5085e0cc6225dbdec63c995fe25faa1fb7c54"
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
	dev-python/rtslib-fb
"
DEPEND="
	dev-python/psutil
"

src_install() {
	emake install DESTDIR="${D}"

	dobin host/start_devserver

	# Install Mob* Monitor checkfiles for the devserver.
	insinto "/etc/mobmonitor/checkfiles/devserver/"
	doins -r "${S}/checkfiles/devserver/"*
}

src_test() {
	# Run the unit tests.
	./run_unittests || die
}
