# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="8826acba1c4e13b6318ae6d1d4b49633d1b55aba"
CROS_WORKON_TREE="c3f25c1a2b4a796faa63f86a667d38b14f849082"
CROS_WORKON_PROJECT="chromiumos/platform/inputcontrol"

inherit cros-workon

DESCRIPTION="A collection of utilities for configuring input devices"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-arch/gzip"
DEPEND=""

src_configure() {
	cros-workon_src_configure
}
