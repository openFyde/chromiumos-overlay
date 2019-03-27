# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="arc/vm/libvda/rust"

inherit cros-workon cros-rust

DESCRIPTION="Rust wrapper for chromeos-base/libvda"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/libvda/rust"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="~*"
IUSE="test"

RDEPEND="
	chromeos-base/libvda:=
"

DEPEND="
	${RDEPEND}
	dev-rust/pkg-config:=
	dev-rust/enumn:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/arc/vm/libvda/rust"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
