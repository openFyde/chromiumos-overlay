# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="98eb44e578e3a267aa6fdc5bb006459d7869eb2a"
CROS_WORKON_TREE=("1a376c7538d71e1cb0369e7fac5d1e6930eeaeaa" "abdc0b82d0fb85747ae777b0d47ee8f3ba66ac08" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk mtpd .gn"
PLATFORM_SUBDIR="mtpd"
PLATFORM_NATIVE_TEST="yes"

inherit cros-workon platform systemd user

DESCRIPTION="MTP daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mtpd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan +seccomp systemd test"

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/protobuf:=
	media-libs/libmtp
	virtual/udev
"

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	exeinto /opt/google/mtpd
	doexe "${OUT}"/mtpd

	# Install seccomp policy file.
	insinto /opt/google/mtpd
	use seccomp && newins "mtpd-seccomp-${ARCH}.policy" mtpd-seccomp.policy

	# Install the init scripts.
	if use systemd; then
		systemd_dounit mtpd.service
		systemd_enable_service system-services.target mtpd.service
	else
		insinto /etc/init
		doins mtpd.conf
	fi

	# Install D-Bus config file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Mtpd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/mtpd_testrunner"
}

pkg_preinst() {
	enewuser "mtp"
	enewgroup "mtp"
}
