# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="c7155fb24a44895f4b829a79e8f94e95393076a6"
CROS_WORKON_TREE=("e96c7b05f7b481bedb62e65f6e9a177306f1b5b2" "10283190f405d2c23f29da68f32bc2931e47a6d6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
