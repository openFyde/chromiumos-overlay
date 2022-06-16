# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="36d20879b0fbe02e2c47f81672bdec7498ef73ff"
CROS_WORKON_TREE="415a9a6a9f3a745d875ac4724076d440cc0da244"
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
	chromeos-base/libsirenia:=
	dev-libs/openssl:0=
	=dev-rust/anyhow-1*:=
	dev-rust/balloon_control:=
	=dev-rust/base64-0.13*:=
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.8*:=
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2.0
	=dev-rust/getopts-0.2*:=
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*:=
	=dev-rust/openssl-0.10*:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
	>=dev-rust/serde_json-1.0.64:= <dev-rust/serde_json-2.0.0
	=dev-rust/stderrlog-0.5*:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
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
