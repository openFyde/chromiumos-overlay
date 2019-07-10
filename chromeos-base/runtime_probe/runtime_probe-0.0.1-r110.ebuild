# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="367fc705d107932356405d25e3427bba9332979a"
CROS_WORKON_TREE=("ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "b261e4d6edb23f37719e645269a83bd5617e454d" "13640994e730146f1a8cbcd0fa744f1bbd6eaba2" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon platform user udev

DESCRIPTION="Runtime probing on device componenets."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/runtime_probe/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="unibuild"

RDEPEND="
	unibuild? ( chromeos-base/chromeos-config )
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo
	chromeos-base/libchrome
	chromeos-base/system_api
"
DEPEND="${RDEPEND}"

# Add vboot_reference as build time dependency to read cros_debug status
DEPEND+=" chromeos-base/vboot_reference "

pkg_preinst() {
	# Create user and group for runtime_probe
	enewuser "runtime_probe"
	enewgroup "cros_ec-access"
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

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/runtime_probe-seccomp-${ARCH}.policy" \
	runtime_probe-seccomp.policy

	# Install udev rules.
	udev_dorules udev/*.rules
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
