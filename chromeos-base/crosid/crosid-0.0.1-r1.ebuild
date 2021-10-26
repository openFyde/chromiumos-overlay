# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="7cf10058163a563bfa0cae966724f0e8581539be"
CROS_WORKON_TREE="6f714a514749ddef295805ba033ecc3f11e2a346"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="chromeos-config"

inherit cros-workon meson

LICENSE="BSD-Google"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-config"
KEYWORDS="*"

src_unpack() {
	cros-workon_src_unpack
	export PYTHONPATH="${S}/platform2/chromeos-config"
	S+="/platform2/chromeos-config/crosid"
}

src_install() {
	dobin "${BUILD_DIR}/crosid"
}

src_test() {
	pytest --executable="${BUILD_DIR}/crosid.test" \
		--llvm-coverage-out="${BUILD_DIR}/coverage.profdata" \
		"${S}" \
		|| die "e2e test suite failed"
}
