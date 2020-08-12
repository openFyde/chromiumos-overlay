# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="420824078ff146bd1931ecfb7b01343664fb8292"
CROS_WORKON_TREE="bb63d3cbc6f2501646b57d6c7c28c4ff1bd8e3ac"
CROS_WORKON_PROJECT="chromiumos/third_party/trousers"
CROS_WORKON_EGIT_BRANCH="master-0.3.13"

inherit cros-workon autotest

DESCRIPTION="Trousers TPM tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/trousers/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
DEPEND="
	app-crypt/trousers
	!<chromeos-base/autotest-tests-0.0.1-r1521
"
RDEPEND="${DEPEND}"

# Enable autotest by default.
IUSE="${IUSE} +autotest"

IUSE_TESTS="
	+tests_hardware_TPM
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME=trousers

# path from root of repo
AUTOTEST_CLIENT_SITE_TESTS=autotest

src_compile() {
	# for Makefile
	export TROUSERS_DIR=${WORKDIR}/${P}
	autotest_src_compile
}

