# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="70ada8046be10beb4d17680c6054b0e84db433c4"
CROS_WORKON_TREE="ba2a65e5030f6074a2c2504f705958d51219d63f"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="sirenia"
CROS_RUST_SUBDIR="${CROS_WORKON_SUBTREE}"

inherit cros-workon cros-rust user

DESCRIPTION="Build tools for the ManaTEE runtime environment."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	dev-libs/openssl:0=
	dev-rust/balloon_control:=
	dev-rust/chromeos-dbus-bindings:=
	dev-rust/data_model:=
	dev-rust/libchromeos:=
	sys-apps/dbus:=
"
# Add host deps in RDEPEND so that they are installed by default in SDK.
RDEPEND="
	sys-apps/dbus
	cros_host? ( ${DEPEND} )
"

src_compile() {
	cros-rust_src_compile --no-default-features --features sdk
}

src_test() {
	cros-rust_src_test --no-default-features --features sdk
}

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/tee_app_info_lint"
}
