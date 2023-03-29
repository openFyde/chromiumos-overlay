# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="4f8e83fb90342298fd26ab5d1472fd6b538b36e1"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "059bd8e13b3e1953f92dc92ddb246594c7a38042" "96a35809ae6da7664ca46f2da1bf479bc2df283f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
#TODO(b/272132524): Remove featured.
CROS_WORKON_SUBTREE="common-mk secagentd featured .gn"

PLATFORM_SUBDIR="secagentd"

inherit cros-workon platform user

DESCRIPTION="Enterprise security event reporting."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secagentd/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+secagentd_min_core_btf proto_force_optimize_speed"

COMMON_DEPEND="
	chromeos-base/attestation-client:=
	chromeos-base/featured:=
	chromeos-base/missive:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/vboot_reference:=
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
