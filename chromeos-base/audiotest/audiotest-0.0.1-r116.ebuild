# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="7cb75dac08220d8362e58525f4953de180839060"
CROS_WORKON_TREE="6a2535bae793dd8869a48946119cc7c6a9ebc18a"
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
