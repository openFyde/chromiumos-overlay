# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1bfc568a14ebb60489bee5641c9d99a22bb94ccc"
CROS_WORKON_TREE="46b3cd5f2d01c3349290e18080884a8b1c16056c"
CROS_WORKON_PROJECT="chromiumos/platform/factory_installer"
CROS_WORKON_LOCALNAME="platform/factory_installer"
CROS_RUST_CRATE_NAME="factory_ufs"
CROS_RUST_SUBDIR="rust/src/factory_ufs"

inherit cros-workon cros-rust

DESCRIPTION="A binary for UFS provisioning written in Rust"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory_installer/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	=dev-rust/anyhow-1*:=
	>=dev-rust/bincode-1.0.1 <dev-rust/bincode-2.0.0_alpha:=
	=dev-rust/glob-0.3*:=
	=dev-rust/serde-1*:=
	>=dev-rust/tempfile-3.2.0 <dev-rust/tempfile-4.0.0_alpha:=
"
RDEPEND="
	sys-apps/ufs-utils
"

src_test() {
	cros-rust_src_test --no-default-features --features="factory-ufs"
}

src_compile() {
	cros-rust_src_compile --no-default-features --features="factory-ufs" \
		--bin="factory_ufs"
}

src_install() {
	dosbin "$(cros-rust_get_build_dir)/factory_ufs"
}
