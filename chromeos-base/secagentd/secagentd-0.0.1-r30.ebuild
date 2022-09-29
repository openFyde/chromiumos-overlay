# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="af7efd1e142cc0e0461ed200476d5455da55b8f3"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "bfcedc00b9c6afdad7d8ab1aec81372210fd85f5" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

# Depending on linux-sources makes it so vmlinux is available on the board
# build root. This is needed so bpftool can generate vmlinux.h at build time.
DEPEND="${COMMON_DEPEND}
	virtual/linux-sources:=
	virtual/pkgconfig:=
"

# bpftool is needed in the SDK to generate C code skeletons from compiled BPF applications.
BDEPEND="
	dev-util/bpftool:=
"

pkg_setup() {
	enewuser "secagentd"
	enewgroup "secagentd"
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/secagentd
}
