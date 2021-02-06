# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_RUST_SUBDIR="sirenia/manatee-runtime"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Library for TEE apps to interact with sirenia."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-runtime/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="~*"

RDEPEND=""

DEPEND="${RDEPEND}
	chromeos-base/libsirenia:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	dev-rust/sync:=
"
