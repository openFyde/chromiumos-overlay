# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="a08e40bf8130ebf215ca4b0724410bd0c964bc41"
CROS_WORKON_TREE="c93b1114453d55f93bf9b5ee719600156ec69716"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="sys_util"
CROS_WORKON_SUBDIRS_TO_COPY="sys_util"

inherit cros-workon cros-rust

DESCRIPTION="Small system utility modules for usage by other modules."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/sys_util"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	sys-libs/libcap:=
"
DEPEND="
	${RDEPEND}
	>=dev-rust/libc-0.2.44:=
	~dev-rust/quote-0.6.10:=
	>=dev-rust/proc-macro2-0.4:=
	>=dev-rust/syn-0.15:=
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
