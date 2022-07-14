# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("e6a8ce119b89e8c36140a2fb36f2352e76dd3be7" "7f61891c586daaf3510d3c4ab4a506b9a650821f")
CROS_WORKON_TREE="3f8196cc1ce7f290d35d0f5969d91f43480a6fe8"
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

DEPEND="sys-firmware/ap-firmware-config:="
RDEPEND="!<chromeos-base/tast-remote-tests-cros-0.0.2"

src_install() {
	tast-bundle-data_src_install
	insinto /usr/share/tast/data/chromiumos/tast/remote/bundles/cros/firmware/data
	doins /usr/share/ap_firmware_config/fw-config.json
}
