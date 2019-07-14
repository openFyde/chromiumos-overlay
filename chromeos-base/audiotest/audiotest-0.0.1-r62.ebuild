# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="fec4565f1d7990a7f15a89ca80778e523fcc367f"
CROS_WORKON_TREE="0ed4ceaf53e9dd7ddf522d6a5fe1112791f38d15"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/audiotest"

inherit cros-sanitizers cros-workon cros-common.mk toolchain-funcs

DESCRIPTION="Audio test tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/audiotest"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="media-libs/alsa-lib
	media-sound/adhd"
DEPEND="${RDEPEND}"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	# Install built tools
	pushd "${OUT}" >/dev/null
	dobin src/alsa_api_test
	dobin src/alsa_conformance_test
	dobin src/alsa_helpers
	dobin src/audiofuntest
	dobin src/cras_api_test
	dobin src/loopback_latency
	dobin script/alsa_conformance_test.py
	popd >/dev/null
}
