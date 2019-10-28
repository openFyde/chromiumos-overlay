# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="b31d7efed4a6114ac30049289ef4f5ae40a050ca"
CROS_WORKON_TREE=("5d53ff58483685bdf4424a3c8e8496656e9aa83e" "c20279913b902dccb872b7888809f4908dc9fa03" "0d26f55599afb8c26f2b6e2813000ae1f9287e7b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="unibuild asan fuzzer"

RDEPEND="
	unibuild? ( chromeos-base/chromeos-config )
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo
	chromeos-base/libchrome
	chromeos-base/system_api[fuzzer?]
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

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
