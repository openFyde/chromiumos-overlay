# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="8c4b2c6b54da967bb5cff8b5f5467559aa1027e2"
CROS_WORKON_TREE=("5d76066514dca6a32e833620a997a659f7fb2fd0" "7c88ab2e4411eb58a2bfb911adf4836f896cec8b" "b770bf56d33ec25b123c27010e34f6673c9c19b7" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform user

DESCRIPTION="U2FHID Emulation Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fhid"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/power_manager-client
	chromeos-base/trunks
	"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
	"

pkg_preinst() {
	enewuser u2f
}

src_install() {
	dobin "${OUT}"/u2fd

	insinto /etc/init
	doins init/*.conf
}
