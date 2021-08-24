# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("4f94ae315355a0204c87c1467e88cac46b701678" "e1968b7c4b9a234c7b7689d8cfc3f944eb212dd2")
CROS_WORKON_TREE="1f273a61462292111cc025e1b0bea547ab6bdfbe"
CROS_WORKON_PROJECT=(
	"chromiumos/platform/tast-tests"
	"chromiumos/platform/fw-testing-configs"
)
CROS_WORKON_LOCALNAME=(
	"platform/tast-tests"
	"platform/tast-tests/src/chromiumos/tast/remote/firmware/data/fw-testing-configs"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/src/chromiumos/tast/remote/firmware/data/fw-testing-configs"
)

# There are symlinks between remote data to local data, so we can't make the
# subtree "src/chromiumos/tast/remote".
# TODO(oka): have a clear separation between local and remote, and make that
# happen.
CROS_WORKON_SUBTREE=("src/chromiumos/tast")

inherit cros-workon tast-bundle-data

DESCRIPTION="Data files for remote Tast tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests"

LICENSE="BSD-Google GPL-3"
SLOT="0/0"
KEYWORDS="*"

DEPEND=""
RDEPEND="!<chromeos-base/tast-remote-tests-cros-0.0.2"
