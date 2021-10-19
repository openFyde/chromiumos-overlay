# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7ead0d20510ead29539a484ff0f63776da7e911b"
CROS_WORKON_TREE=("2db51c30fffacaf0d9efa17346ea22077add35ec" "58be5098716e7df76045940d9d1b652ca9b1cfd7")
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
	=dev-rust/anyhow-1*:=
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
