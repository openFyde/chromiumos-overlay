# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="a3c495a9f5657c3778e5179d1c1ba073ad26020b"
CROS_WORKON_TREE="73cce14d35b05e518d243f94d8466463cdce4ead"
CROS_WORKON_PROJECT="chromiumos/platform/microbenchmarks"
CROS_WORKON_LOCALNAME="../platform/microbenchmarks"

inherit cros-workon cros-common.mk

DESCRIPTION="Home for microbenchmarks designed in-house."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/microbenchmarks"

LICENSE="BSD-Google"
KEYWORDS="*"

src_install() {
	dobin "${OUT}"/memory-eater/memory-eater
}
