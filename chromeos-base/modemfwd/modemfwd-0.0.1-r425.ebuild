# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8d55c2520a35331e9d06682424c7dc9ad0cbdaed"
CROS_WORKON_TREE=("f577121f2538fbe78584b4fe59c478a26bf80df4" "5c4e07da72e833ffc77890eb46b0a2982a23fe52" "740a1b80b3ad3059019c079cebeedc792b911b24" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config modemfwd .gn"

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

	# DBus configuration
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Modemfwd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/modemfw_test"
}
