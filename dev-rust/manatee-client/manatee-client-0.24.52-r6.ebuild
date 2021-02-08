# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ceeaf6e4d7a1270061aa440d91faa3a52b744c30"
CROS_WORKON_TREE=("c2fe120f7a53b772a14d7477e3aef523b09d1253" "3508d2f3db0647ef3871071db0b2fbfd7b6af042")
CROS_RUST_SUBDIR="sirenia/manatee-client"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} sirenia/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-client"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	=dev-rust/dbus-0.8*:=
	dev-rust/chromeos-dbus-bindings:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"

src_install() {
	cros-rust_src_install

	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/manatee"
}
