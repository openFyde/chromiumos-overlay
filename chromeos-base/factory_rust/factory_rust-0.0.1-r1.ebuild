# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e8d0ce9c4326f0e57235f1acead1fcbc1ba2d0b9"
CROS_WORKON_TREE="f365214c3256d3259d78a5f4516923c79940b702"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon

DESCRIPTION="This ebuild defines the rust dependencies used in factory_installer dir."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory_installer/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	=dev-rust/anyhow-1*:=
	>=dev-rust/bincode-1.0.1 <dev-rust/bincode-2.0.0_alpha:=
	>=dev-rust/clap-3.1.0 <dev-rust/clap-4.0.0:=
	=dev-rust/glob-0.3*:=
	>=dev-rust/serde-1.0.0 <dev-rust/serde-2.0.0:=
	>=dev-rust/serde_json-1.0.0 <dev-rust/serde_json-2.0.0:=
	>=dev-rust/tempfile-3.2.0 <dev-rust/tempfile-4.0.0_alpha:=
"
