# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c4ad9a5dd8f6fadb3d563f928a9181a1a121ce0f"
CROS_WORKON_TREE="3fa7f51aba275dc2cd92e4880d8c6ed1d43821c7"
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
