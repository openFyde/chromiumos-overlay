# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb44783f2742a490da4365a5c354a86285130f03"
CROS_WORKON_TREE=("76e38f12c60603f6cf7e7e28cebb55fba4849c09" "3508d2f3db0647ef3871071db0b2fbfd7b6af042")
CROS_RUST_SUBDIR="sirenia/manatee-client"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} sirenia/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-client"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND="sys-apps/dbus"
DEPEND="${RDEPEND}
	chromeos-base/libsirenia:=
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/getopts-0.2*:=
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*:=
	=dev-rust/stderrlog-0.5*:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
	=dev-rust/which-4*:=
"

src_install() {
	cros-rust_src_install

	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/manatee"
}
