# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="398139c9c26b93444bde590636c5e3813cc3808d"
CROS_WORKON_TREE="e51266d646616e6c0bea40882fc482425e982936"
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

src_configure() {
	emesonargs+=( -Ddefault_library=both )
	meson_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/crosid"
	dolib.a "${BUILD_DIR}/libcrosid.a"
	dolib.so "${BUILD_DIR}/libcrosid.so"
	doheader "${S}/crosid.h"

	meson_src_install
}

src_test() {
	pytest --executable="${BUILD_DIR}/crosid.test" \
		--llvm-coverage-out="${BUILD_DIR}/coverage.profdata" \
		"${S}" \
		|| die "e2e test suite failed"
}
