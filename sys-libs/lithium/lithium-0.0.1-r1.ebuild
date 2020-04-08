# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="225a1684941c7186f102c25d3f63e19e40f69914"
CROS_WORKON_TREE="b47e5cc30cc0985057083a0a42a13b8c34c79c0d"
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
