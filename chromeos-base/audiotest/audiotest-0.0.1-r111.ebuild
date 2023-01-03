# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="e660e924cd0373ec22114f77ffd55058aa6d3821"
CROS_WORKON_TREE="4e38a728b3255081a8336238a44f9eea9a916ba2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/audiotest"
CROS_WORKON_LOCALNAME="platform/audiotest"

inherit cros-sanitizers cros-workon cros-common.mk

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
	export WITH_CRAS=true
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_test() {
	pushd script || die
	python3 -m unittest cyclic_bench_unittest || die
	popd > /dev/null || die
}

src_install() {
	# Install built tools
	pushd "${OUT}" >/dev/null || die
	dobin src/alsa_api_test
	dobin alsa_conformance_test/alsa_conformance_test
	dobin src/alsa_helpers
	dobin src/audiofuntest
	dobin src/cras_api_test
	dobin loopback_latency/loopback_latency
	dobin script/alsa_conformance_test.py
	dobin script/cyclic_bench.py
	popd >/dev/null || die
}
