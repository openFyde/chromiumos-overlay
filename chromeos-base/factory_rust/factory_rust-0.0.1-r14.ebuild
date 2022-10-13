# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="d2d95e8af89939f893b1443135497c1f5572aebc"
CROS_WORKON_TREE="776139a53bc86333de8672a51ed7879e75909ac9"
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
	dev-rust/third-party-crates-src:=
	=dev-rust/anyhow-1*
	>=dev-rust/bincode-1.0.1 <dev-rust/bincode-1.1.0_alpha
	>=dev-rust/clap-3.1.0 <dev-rust/clap-4.0.0_alpha
	=dev-rust/glob-0.3*
	>=dev-rust/hmac-sha256-0.1.7 <dev-rust/hmac-sha256-0.2.0_alpha
	=dev-rust/serde_json-1*
	>=dev-rust/tempdir-0.3.7 <dev-rust/tempdir-0.4.0_alpha
	>=dev-rust/tempfile-3.2.0 <dev-rust/tempfile-4.0.0_alpha
"
