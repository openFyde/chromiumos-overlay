# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon

DESCRIPTION="This ebuild defines the rust dependencies used in factory_installer dir."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory_installer/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE=""

DEPEND="
	=dev-rust/anyhow-1*:=
	>=dev-rust/bincode-1.0.1 <dev-rust/bincode-1.1.0_alpha:=
	>=dev-rust/byteorder-1.4.3 <dev-rust/byteorder-2.0.0_alpha:=
	>=dev-rust/clap-3.1.0 <dev-rust/clap-4.0.0_alpha:=
	=dev-rust/glob-0.3*:=
	>=dev-rust/hmac-sha256-0.1.7 <dev-rust/hmac-sha256-0.2.0_alpha:=
	=dev-rust/libc-0.2*:=
	=dev-rust/regex-1*:=
	=dev-rust/serde-1*:=
	=dev-rust/serde_json-1*:=
	>=dev-rust/tempfile-3.2.0 <dev-rust/tempfile-4.0.0_alpha:=
"
