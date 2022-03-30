# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="333ec877d7bb10d72a63c372db16ae5f1dbac0b9"
CROS_WORKON_TREE="c440263ac6c3eaa96b9b5d5e6d1c093b8835f5d9"
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
