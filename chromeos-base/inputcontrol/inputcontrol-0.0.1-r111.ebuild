# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="4c0c21a9a02024f5c9913c1c7d0f74f100e861d1"
CROS_WORKON_TREE="19837649b7a41d54284ed6538cbbe44e9109fb60"
CROS_WORKON_PROJECT="chromiumos/platform/inputcontrol"
CROS_WORKON_LOCALNAME="platform/inputcontrol"

inherit cros-workon

DESCRIPTION="A collection of utilities for configuring input devices"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-arch/gzip"
DEPEND=""

src_configure() {
	cros-workon_src_configure
}
