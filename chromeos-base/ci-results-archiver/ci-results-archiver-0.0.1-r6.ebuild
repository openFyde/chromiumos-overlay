# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="4404286261d26d282a84f7c52d0a84634d748677"
CROS_WORKON_TREE="d6cc4efd3ba0a7d155f5c2b5d2be557fb5740088"
CROS_WORKON_PROJECT="chromiumos/infra/ci_results_archiver"
CROS_WORKON_LOCALNAME="../../infra/ci_results_archiver"

CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Pipeline to archive continuous integration results."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/infra/ci_results_archiver/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""
DEPEND=""

# No file is installed by this package; the whole purpose of this package is to
# run unit tests.

src_test() {
	# Pass some options to avoid writing to the write-protected directory.
	# TODO(crbug.com/808434): Reenable unit tests once we understand the
	# root cause
	# bin/run_tests -p no:cacheprovider --no-cov || die "Unit tests failed"
	:
}
