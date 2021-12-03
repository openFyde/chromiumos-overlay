# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='Lightweight non-blocking IO'
HOMEPAGE='https://github.com/tokio-rs/mio'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/log-0.4.8 <dev-rust/log-0.5.0_alpha:=
	>=dev-rust/libc-0.2.86 <dev-rust/libc-0.3.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
