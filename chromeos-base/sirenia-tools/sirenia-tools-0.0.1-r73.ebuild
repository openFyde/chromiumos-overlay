# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="21e6045802b93dcf60c69459602139dbbffb2ea8"
CROS_WORKON_TREE="452ac96725f475d7c3755c90ff83c086e65ae63e"
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
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	dev-libs/openssl:0=
	=dev-rust/anyhow-1*:=
	=dev-rust/assert_matches-1*:=
	dev-rust/balloon_control:=
	dev-rust/chromeos-dbus-bindings:=
	dev-rust/data_model:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/dbus-crossroads-0.5*:=
	=dev-rust/flexbuffers-2*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/libc-0.2*:=
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*:=
	=dev-rust/multi_log-0.1*:=
	=dev-rust/serde-1*:=
	=dev-rust/serde_derive-1*:=
	=dev-rust/serde_json-1*:=
	=dev-rust/stderrlog-0.5*:=
	=dev-rust/syslog-4*:=
	=dev-rust/thiserror-1*:=
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
