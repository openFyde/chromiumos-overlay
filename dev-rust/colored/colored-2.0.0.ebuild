# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='The most simple way to add colors in your terminal'
HOMEPAGE='https://github.com/mackwic/colored'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MPL-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/atty-0.2*
	=dev-rust/lazy_static-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

RESTRICT="test"
