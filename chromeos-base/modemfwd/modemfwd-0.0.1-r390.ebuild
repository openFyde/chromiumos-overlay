# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c5e129fb04bd33feb66f15cbcea3b816b1805d69"
CROS_WORKON_TREE=("abb168d9ecda9d00ce3e63c48d60028b32492066" "172542572f020bda8eb8cef5590fc44705b06303" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk modemfwd .gn"

PLATFORM_SUBDIR="modemfwd"

inherit cros-workon platform user

DESCRIPTION="Modem firmware updater daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/modemfwd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-arch/xz-utils:=
	chromeos-base/chromeos-config
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo
	dev-libs/protobuf:=
"

DEPEND="${RDEPEND}
	chromeos-base/shill-client
	chromeos-base/system_api
"

src_install() {
	dobin "${OUT}/modemfwd"

	# Upstart configuration
	insinto /etc/init
	doins modemfwd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/modemfw_test"
}
