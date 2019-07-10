# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="ChromiumOS Devserver Dependencies."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# These packages are meant to provide a basic enviornment for running the
# ChromiumOS Devsever code.
RDEPEND="
	dev-lang/python
	dev-python/protobuf-python
	dev-python/cherrypy
	net-misc/gsutil
	dev-python/rtslib-fb
	chromeos-base/update_payload
"

DEPEND=""

S=${WORKDIR}
