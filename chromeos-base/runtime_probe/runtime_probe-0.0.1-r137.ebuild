# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="2617f00881f2c53b7ebe6c103f4165845e3b67ef"
CROS_WORKON_TREE=("b050a2ab2836dd6da5e48eab3fd4ac328d4325bc" "6f899111713b76290da6818adf032ce6d7d23147" "7abf9fc60491bdec73ac18a9d139cd21f395cb3f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dobin "${OUT}/runtime_probe_helper"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.RuntimeProbe.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.RuntimeProbe.service


	# Install sandbox information.
	insinto /etc/runtime_probe/sandbox
	doins sandbox/*.args
	doins sandbox/"${ARCH}"/*-seccomp.policy

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
