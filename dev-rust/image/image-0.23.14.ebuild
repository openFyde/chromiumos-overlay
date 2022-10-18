# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Imaging library written in Rust. Provides basic filters and decoders for the most common image formats.'
HOMEPAGE='https://github.com/image-rs/image'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/bytemuck-1*
	=dev-rust/dav1d-0.6*
	>=dev-rust/dcv-color-primitives-0.1.16 <dev-rust/dcv-color-primitives-0.2.0_alpha
	>=dev-rust/gif-0.11.1 <dev-rust/gif-0.12.0_alpha
	>=dev-rust/mp4parse-0.11.5 <dev-rust/mp4parse-0.12.0_alpha
	=dev-rust/num-rational-0.3*
	>=dev-rust/png-0.16.5 <dev-rust/png-0.17.0_alpha
	=dev-rust/ravif-0.6*
	>=dev-rust/rgb-0.8.25 <dev-rust/rgb-0.9.0_alpha
	=dev-rust/scoped_threadpool-0.1*
	=dev-rust/tiff-0.6*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# Disable tests because only the 'png' feature of this crate works,
# the other features have unsatisfied dependencies.
RESTRICT="test"
