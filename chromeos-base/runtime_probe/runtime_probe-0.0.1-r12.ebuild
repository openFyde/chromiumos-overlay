# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="922305dce67d1f29491bf064d01f81767c7ab15d"
CROS_WORKON_TREE=("6f3635a6f5b0951a7ffdebd896518c01b04cc21b" "c0c20742c4b56834cde30d6151beec01d4198f31" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon platform user

DESCRIPTION="Runtime probing on device componenets."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/runtime_probe/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/libchrome
	chromeos-base/system_api
"
DEPEND="${RDEPEND}
"

pkg_preinst() {
	# Create user and group for runtime_probe
	enewuser "runtime_probe"
	enewgroup "runtime_probe"
}

src_install() {
	dobin "${OUT}/runtime_probe"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.RuntimeProbe.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.RuntimeProbe.service
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
