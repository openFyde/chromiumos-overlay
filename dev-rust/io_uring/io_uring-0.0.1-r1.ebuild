# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e425f57d5bfc3c1344156144ba67161b6291f7b5"
CROS_WORKON_TREE="70bb0bb71d8a5eeb3a9286bbc1015157fda55782"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="io_uring"
CROS_WORKON_SUBDIRS_TO_COPY="io_uring"

# TODO: Enable tests on ARM once the emulator supports io_uring.
CROS_RUST_TEST_DIRECT_EXEC_ONLY="yes"

inherit cros-workon cros-rust

DESCRIPTION="Safe wrappers around the linux kernel's io_uring interface"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/main/io_uring"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	dev-rust/data_model:=
	>=dev-rust/libc-0.2.65:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	dev-rust/syscall_defines:=
	dev-rust/tempfile:=
"
RDEPEND="${DEPEND}"
