# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="db0799fdd3989ae3c6e92f8a8583a7515a496435"
CROS_WORKON_TREE="92d41e1d76de84e19ce924a08931bf722c8a6b57"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest policy deps"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="policy_protos"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

DEPEND="
	>=chromeos-base/protofiles-0.0.43:=
	chromeos-base/system_api
	dev-libs/protobuf:=
"

# Calling this here, so tests using this dep don't have to call setup_dep().
src_prepare() {
	autotest-deponly_src_prepare
}
