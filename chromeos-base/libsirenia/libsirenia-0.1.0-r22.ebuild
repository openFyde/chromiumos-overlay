# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="98bffc317ef0ffd5e1ff7d09a66b7941d2bcc38c"
CROS_WORKON_TREE="d9a7c219b4a081df0f9903f4b27e7f08937ec0fa"
CROS_RUST_SUBDIR="sirenia/libsirenia"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="The support library for the ManaTEE runtime environment."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/libsirenia"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	chromeos-base/sirenia-rpc-macros:=
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2
	=dev-rust/getopts-0.2*:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	dev-rust/libchromeos:=
	dev-rust/minijail:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"

# We skip the vsock test because it requires the vsock kernel modules to be
# loaded.
src_test() {
	cros-rust_src_test -- --skip transport::tests::vsocktransport \
		--skip sandbox::tests::sandbox_unpriviledged

	# TODO(crbug.com/1171078) Run this with the other tests.
	(
		local timeout_millis=5000
		CROS_RUST_PLATFORM_TEST_ARGS=(
			"${CROS_RUST_PLATFORM_TEST_ARGS[@]}"
			--env RUST_TEST_TIME_UNIT="${timeout_millis},${timeout_millis}"
		)
		cros-rust_src_test -- --nocapture \
			-Z unstable-options --ensure-time \
			sandbox::tests::sandbox_unpriviledged
	)

	if cros_rust_is_direct_exec; then
		# Run tests for sirenia-rpc-macros here since the tests depend on libsirenia
		# and libsirenia depends on sirenia-rpc-macros.
		(
			cd sirenia-rpc-macros || die
			cros-rust_src_test
		)
	fi
}
