# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="28c3b07e81c11c5ddf723f1016c6b1ef5b2b78fe"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "3b0507b2cd41d3cd08947e264c6edd94e265e07e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
IUSE="+secagentd_min_core_btf"

COMMON_DEPEND="
	chromeos-base/attestation-client:=
	chromeos-base/featured:=
	chromeos-base/missive:=
	chromeos-base/tpm_manager-client:=
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
# pahole is needed in the SDK to generate vmlinux.h and detached BTFs.
BDEPEND="
	dev-util/bpftool:=
	dev-util/pahole:=
"

pkg_setup() {
	enewuser "secagentd"
	enewgroup "secagentd"
	cros-workon_pkg_setup
}

src_install() {
	platform_src_install

	dosbin "${OUT}"/secagentd
	if use secagentd_min_core_btf; then
		insinto /usr/share/btf/secagentd
		doins "${OUT}"/gen/btf/*.min.btf
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/secagentd_testrunner"
}
