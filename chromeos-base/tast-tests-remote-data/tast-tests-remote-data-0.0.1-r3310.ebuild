# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("22b9b9f93b4f9f875d8de20afbc1198eab4df8e5" "fce37fd7709bcecfe2bb3a1e1a19efa6131afb31")
CROS_WORKON_TREE="47a59e979381eec76fc0d6b177942666001ddbac"
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
