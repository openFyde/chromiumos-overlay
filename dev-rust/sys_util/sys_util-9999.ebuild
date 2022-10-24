# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/sys_util"
CROS_WORKON_SUBDIRS_TO_COPY=("${CROS_RUST_SUBDIR}" .cargo)
CROS_WORKON_SUBTREE="${CROS_WORKON_SUBDIRS_TO_COPY[*]}"

# The version of this crate is pinned. See b/229016539 for details.
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-workon cros-rust

DESCRIPTION="Small system utility modules for usage by other modules."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/sys_util"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="test"

# ebuilds that install executables, import sys_util, and use the libcap
# functionality need to RDEPEND on libcap
DEPEND="
	dev-rust/third-party-crates-src:=
	dev-rust/assertions:=
	dev-rust/sys_util_core:=
	dev-rust/data_model:=
	=dev-rust/serde_json-1*
	dev-rust/sync:=
	dev-rust/tempfile
	sys-libs/libcap:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/sys_util-0.1.0-r60
"

src_test() {
	local skip_tests=()

	# These tests directly make a clone(2) syscall, which makes sanitizers very
	# unhappy since they see memory allocated in the child process that is not
	# freed (because it is owned by some other thread created by the test runner
	# in the parent process).
	cros-rust_use_sanitizers && skip_tests+=(--skip "fork::tests")
	# The memfd_create() system call first appeared in Linux 3.17.  Skip guest
	# memory tests for builders with older kernels.
	local cut_version=$(ver_cut 1-2 "$(uname -r)")
	if ver_test 3.17 -gt "${cut_version}"; then
		skip_tests+=(--skip "guest_memory::tests")
	fi

	# If syslog isn't available, skip the tests.
	[[ -S /dev/log ]] || skip_tests+=(--skip "syslog::tests")

	# TODO(crbug.com/1157570) Remove once syslog module works in sandbox.
	CROS_RUST_TEST_DIRECT_EXEC_ONLY="yes"
	cros-rust_get_host_test_executables

	cros-rust_src_test -- --test-threads=1 "${skip_tests[@]}"
}

# This crate has moved from sys_util to sys_util_core, however we need to prevent
# this ebuild file from removing the symlinks added by sys_util_core after they were installed.
# TODO(b/219578294): Remove once eclass is updated to handle this case.
pkg_postinst() {
	cros-rust_pkg_postinst poll_token_derive
	cros-rust_pkg_postinst
}
