# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="bec689a83d442623fd0f110b8f5ca411aa59a9fd"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "0e27fcf3db77ce2ea5e204cba2d598db32cd2c71" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk pciguard .gn"

PLATFORM_SUBDIR="pciguard"

inherit cros-workon platform user

DESCRIPTION="Chrome OS External PCI device security daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/pciguard/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

DEPEND="
	chromeos-base/system_api:=
"

src_install() {
	# Install the binary
	dosbin "${OUT}"/pciguard

	# Install the seccomp policy
	insinto /usr/share/policy
	newins "${S}/seccomp/pciguard-seccomp-${ARCH}.policy" pciguard-seccomp.policy

	# Install the upstart configuration files
	insinto /etc/init
	doins "${S}"/init/pciguard.conf

	# Install the dbus configuration
	insinto /etc/dbus-1/system.d
	doins "${S}/dbus/pciguard-dbus.conf"
}

pkg_preinst() {
	enewuser pciguard
	enewgroup pciguard
	cros-workon_pkg_setup
}
