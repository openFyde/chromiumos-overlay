# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/io_uring"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"
CROS_WORKON_SUBDIRS_TO_COPY="${CROS_RUST_SUBDIR}"

# TODO: Enable tests on ARM once the emulator supports io_uring.
CROS_RUST_TEST_DIRECT_EXEC_ONLY="yes"

# Pupr handles uprevs of crosvm.
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-workon cros-rust

DESCRIPTION="Safe wrappers around the linux kernel's io_uring interface"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/io_uring"
LICENSE="BSD-Google"
KEYWORDS="~*"

DEPEND="
	dev-rust/data_model:=
	>=dev-rust/libc-0.2.93:=
	=dev-rust/remain-0.2*:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	dev-rust/tempfile:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"
RDEPEND="${DEPEND}"

src_test() {
	# The io_uring implementation on kernels older than 5.10 was buggy so skip
	# them if we're running on one of those kernels.
	local cut_version="$(ver_cut 1-2 "$(uname -r)")"
	if ver_test "${cut_version}" -lt 5.10; then
		einfo "Skipping io_uring tests on kernel version < 5.10"
	else
		cros-rust_src_test
	fi
}
