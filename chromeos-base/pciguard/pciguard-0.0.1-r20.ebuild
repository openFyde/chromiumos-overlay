# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="d7d02e3d3be256c2f8a276083494cb73428fa44f"
CROS_WORKON_TREE=("c23e9bd8eaa54cbd599b1a7aca04009fd33af563" "dd0390ea72e962ec1f5a43a65822bb798ad0e046" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	doins "${S}"/init/*.conf

	# Install the dbus configuration
	insinto /etc/dbus-1/system.d
	doins "${S}/dbus/pciguard-dbus.conf"
}

pkg_preinst() {
	enewuser pciguard
	enewgroup pciguard
	cros-workon_pkg_setup
}
