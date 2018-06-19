# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"
CROS_WORKON_COMMIT="400392573b5ad53f9c9b34bfaa7383b8652da678"
CROS_WORKON_TREE="3ef6537c5f00f114362c7f44b1ec1923adcc34eb"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon autotest

DESCRIPTION="Autotest for the ML Service"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

IUSE="+autotest"

CLIENT_IUSE_TESTS="
	+tests_ml_CheckMlProcesses
"

IUSE_TESTS="${IUSE_TESTS}
	${CLIENT_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_configure() {
	cros-workon_src_configure
}
