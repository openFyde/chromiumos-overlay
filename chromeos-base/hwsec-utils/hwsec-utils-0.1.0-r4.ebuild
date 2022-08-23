# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="7e43e6097d9692c9ce403c550d4c58e7985ca5db"
CROS_WORKON_TREE="7861fdf86d5bfa2bc82ec65872acea7caccbfa0d"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="hwsec-utils"

inherit cros-workon cros-rust

DESCRIPTION="Hwsec-related features."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test cr50_onboard"



DEPEND=""
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
"


src_install() {
	cros-rust_src_install
	dobin "$(cros-rust_get_build_dir)/tpm2_read_board_id"
}

src_test() {
	cros-rust_src_test
}
