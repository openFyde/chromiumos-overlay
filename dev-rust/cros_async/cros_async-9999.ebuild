# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="cros_async"
CROS_WORKON_SUBDIRS_TO_COPY="cros_async"

inherit cros-workon cros-rust

DESCRIPTION="Rust async tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/main/cros_async"

LICENSE="BSD-Google"
KEYWORDS="~*"

DEPEND="
	=dev-rust/async-task-4*:=
	>=dev-rust/async-trait-0.1.36:= <dev-rust/async-trait-0.2
	dev-rust/data_model:=
	=dev-rust/futures-0.3*:=
	dev-rust/io_uring:=
	>=dev-rust/libc-0.2.93:= <dev-rust/libc-0.3
	=dev-rust/paste-1*:=
	=dev-rust/pin-utils-0.1*:=
	=dev-rust/slab-0.4*:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	dev-rust/tempfile:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2
"
RDEPEND="${DEPEND}"

src_test() {
	# TODO: Enable tests on ARM once the emulator supports io_uring.
	if ! cros_rust_is_direct_exec; then
		einfo "Skipping uring tests on non-x86 platform"
		local skip_tests=(
			ring
			io_ext
			timer::tests::one_shot
		)

		local args=( $(printf -- "--skip %s\n" "${skip_tests[@]}") )
		cros-rust_src_test -- "${args[@]}"
	else
		cros-rust_src_test
	fi
}
