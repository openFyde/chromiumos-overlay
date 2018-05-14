# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CROS_WORKON_COMMIT="8826acba1c4e13b6318ae6d1d4b49633d1b55aba"
CROS_WORKON_TREE="c3f25c1a2b4a796faa63f86a667d38b14f849082"
CROS_WORKON_PROJECT="chromiumos/platform/inputcontrol"

inherit cros-workon

DESCRIPTION="A collection of utilities for configuring input devices"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="+X"

RDEPEND="
	app-arch/gzip
	X? ( x11-apps/xinput )
"
DEPEND="${RDEPEND}"

src_configure() {
	export HAVE_XINPUT=$(usex X 1 0)
	cros-workon_src_configure
}
