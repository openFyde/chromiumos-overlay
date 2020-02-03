# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Install Chromium binary tests to test image"
HOMEPAGE="http://www.chromium.org"
SRC_URI=""

LICENSE="BSD-Google"

SLOT="0"
KEYWORDS="*"
IUSE="vaapi"
S="${WORKDIR}"

DEPEND="chromeos-base/chromeos-chrome"

src_install() {
	exeinto /usr/libexec/chrome-binary-tests
	# The binary tests in ${BINARY_DIR} are built by chrome-chrome.
	# If you add/remove a binary here, please also do so for
	# CHROME_TEST_BINARIES in src/platform/bisect-kit/bisect_kit/cr_util.py
	BINARY_DIR="${SYSROOT}/usr/local/build/autotest/client/deps/chrome_test/test_src/out/Release"
	doexe "${BINARY_DIR}/capture_unittests"
	doexe "${BINARY_DIR}/dawn_end2end_tests"
	doexe "${BINARY_DIR}/dawn_unittests"
	doexe "${BINARY_DIR}/jpeg_decode_accelerator_unittest"
	doexe "${BINARY_DIR}/jpeg_encode_accelerator_unittest"
	doexe "${BINARY_DIR}/ozone_gl_unittests"
	doexe "${BINARY_DIR}/sandbox_linux_unittests"
	doexe "${BINARY_DIR}/video_decode_accelerator_perf_tests"
	doexe "${BINARY_DIR}/video_decode_accelerator_tests"
	doexe "${BINARY_DIR}/video_encode_accelerator_unittest"
	doexe "${BINARY_DIR}/wayland_client_perftests"

	if use vaapi; then
		doexe "${BINARY_DIR}/vaapi_unittest"
	fi
}
