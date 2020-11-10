# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b3fca20e24b8559d5de157342b89ca44785a3928"
CROS_WORKON_TREE="b55566e74ab32bb62ee70d89f754a503e075b120"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="sys_util"
CROS_WORKON_SUBDIRS_TO_COPY="sys_util"

inherit cros-workon cros-rust

DESCRIPTION="Small system utility modules for usage by other modules."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/sys_util"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	sys-libs/libcap:=
	!!<=dev-rust/sys_util-0.1.0-r60
"
DEPEND="
	${RDEPEND}
	=dev-rust/android_log-sys-0.2*:=
	>=dev-rust/libc-0.2.44:=
	=dev-rust/quote-1*:=
	=dev-rust/proc-macro2-1*:=
	=dev-rust/syn-1*:=
	dev-rust/data_model:=
	dev-rust/sync:=
	dev-rust/syscall_defines:=
	dev-rust/tempfile:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/sys_util"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	local skip_tests=()

	# These tests directly make a clone(2) syscall, which makes sanitizers very
	# unhappy since they see memory allocated in the child process that is not
	# freed (because it is owned by some other thread created by the test runner
	# in the parent process).
	cros-rust_use_sanitizers && skip_tests+=( --skip "fork::tests" )
	# The memfd_create() system call first appeared in Linux 3.17.  Skip guest
	# memory tests for builders with older kernels.
	local cut_version=$(ver_cut 1-2 "$(uname -r)")
	if ver_test 3.17 -gt "${cut_version}"; then
		skip_tests+=( --skip "guest_memory::tests" )
	fi

	if use x86 || use amd64; then
		# Some tests must be run single threaded to ensure correctness,
		# since they rely on wait()ing on threads spawned by the test.
		ecargo_test -- --test-threads=1 "${skip_tests[@]}"
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	pushd poll_token_derive > /dev/null
	cros-rust_publish poll_token_derive "$(cros-rust_get_crate_version ${S}/poll_token_derive)"
	popd > /dev/null

	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}

pkg_postinst() {
	cros-rust_pkg_postinst poll_token_derive
	cros-rust_pkg_postinst
}

pkg_prerm() {
	cros-rust_pkg_prerm poll_token_derive
	cros-rust_pkg_prerm
}

