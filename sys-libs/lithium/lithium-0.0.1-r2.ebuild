# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="862e052ca29210773cbda6e2d63201026e5ede68"
CROS_WORKON_TREE="401a18f0ed52bb5b8acbc254a4207a00014afbcc"
CROS_WORKON_PROJECT="chromiumos/platform/lithium"
CROS_WORKON_LOCALNAME="../platform/lithium"
CROS_WORKON_DESTDIR="${S}/platform/lithium"

inherit toolchain-funcs cros-workon

DESCRIPTION="C library for systems programming and unit testing"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/lithium"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0"

src_unpack() {
	cros-workon_src_unpack
	S+="/platform/lithium"
}

src_configure() {
	tc-export CC AR
}

src_compile() {
	emake build/release/libithium.so
}

src_install() {
	dolib.so build/release/libithium.so
	insinto /usr/include/lithium
	doins -r include/*
}

src_test() {
	emake run-tests
}
