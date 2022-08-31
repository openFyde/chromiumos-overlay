# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="1bf36c886ffe11a1863eb73b2244464a2da40632"
CROS_WORKON_TREE=("e9b5125e1997da827cca1bbd3b21829a4037c402" "428ca0362713416853ded38372bd112dfea92c2a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk secagentd .gn"

PLATFORM_SUBDIR="secagentd"

inherit cros-workon platform user

DESCRIPTION="Enterprise security event reporting."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secagentd/"
LICENSE="BSD-Google"
KEYWORDS="*"
COMMON_DEPEND="
	chromeos-base/missive:=
	>=dev-libs/libbpf-0.8.1
"
RDEPEND="${COMMON_DEPEND}
	>=sys-process/audit-3.0
"
DEPEND="${COMMON_DEPEND}
	dev-util/bpftool:=
	virtual/linux-sources:=
	virtual/pkgconfig:=
"

BDEPEND="${COMMON_DEPEND}
	>=sys-devel/llvm-15.0_pre458507_p20220602-r13
"

pkg_setup() {
	enewuser "secagentd"
	enewgroup "secagentd"
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/secagentd
}
