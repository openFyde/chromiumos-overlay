# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9a2de0d377fdae131802e2c260721d2203d78009"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "183f2a0d12d9959a9529dfa049f6e75d48630a31" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE="-asan +seccomp systemd test"

COMMON_DEPEND="
	dev-libs/protobuf:=
	media-libs/libmtp:=
	virtual/udev
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	dosbin "${OUT}"/mtpd

	# Install seccomp policy file.
	insinto /usr/share/policy
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
