# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3e39f075c250c4c15cf3657ec76643261c80c4bd"
CROS_WORKON_TREE="877e51658c681bf4deb4312ab6ff055ff8637c97"
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
