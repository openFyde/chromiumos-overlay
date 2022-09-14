# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="27ca9604e823b11043a77b2c4fdcf2a84b2520d1"
CROS_WORKON_TREE="17f2b70aeaed1c5afee2d57f11bc1ff6f98846b8"
CROS_WORKON_PROJECT="chromiumos/platform/factory_installer"
CROS_WORKON_LOCALNAME="platform/factory_installer"
CROS_RUST_CRATE_NAME="factory_ufs"
CROS_RUST_SUBDIR="rust"

inherit cros-workon cros-rust

DESCRIPTION="A binary for UFS provisioning written in Rust"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory_installer/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="chromeos-base/factory_rust"
RDEPEND="
	sys-apps/ufs-utils
"

src_test() {
	cros-rust_src_test --no-default-features --features="factory-ufs" \
		--lib
}

src_compile() {
	cros-rust_src_compile --no-default-features --features="factory-ufs" \
		--bin="factory_ufs"
}

src_install() {
	dosbin "$(cros-rust_get_build_dir)/factory_ufs"
}
