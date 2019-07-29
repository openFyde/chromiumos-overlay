# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="8b6887858c29d2e704b696110560298935f40896"
CROS_WORKON_TREE="9f6bd7c8671421de088a8b2832d7080e11946053"
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
