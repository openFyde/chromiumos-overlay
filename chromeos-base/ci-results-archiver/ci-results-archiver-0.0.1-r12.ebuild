# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="0d3a1c8342593f4dff817a99d85338c30a2cea8b"
CROS_WORKON_TREE="fe0ab9302c15bd4b6cd94b473b9317c44ee24d23"
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
