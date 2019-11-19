# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="c304d6ed37320a76dcaf4d3b543a14140bc98cef"
CROS_WORKON_TREE=("c9338e2c2e898e065dce6d62921e358a85709cd3" "4c75ca8d9827c57bf2fa0caab19a8709ac465de1" "efb32517f1688037d9c8d49c6e0ea149d6bb3b67" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk lorgnette metrics .gn"

PLATFORM_SUBDIR="lorgnette"

inherit cros-workon platform

DESCRIPTION="Document Scanning service for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/minijail
	chromeos-base/libbrillo
	chromeos-base/metrics
	media-gfx/sane-backends
	media-gfx/pnm2png
"

DEPEND="${RDEPEND}
	chromeos-base/permission_broker-client
	chromeos-base/system_api
"

src_install() {
	dobin "${OUT}"/lorgnette
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.lorgnette.conf
	insinto /usr/share/dbus-1/system-services
	doins dbus_service/org.chromium.lorgnette.service
}

platform_pkg_test() {
	platform_test "run" "${OUT}/lorgnette_unittest"
}
