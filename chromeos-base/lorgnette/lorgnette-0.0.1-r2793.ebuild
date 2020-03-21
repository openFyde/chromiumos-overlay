# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c90aa6f17dcbdeaf4e7c5ce155f3a685afdbfd01"
CROS_WORKON_TREE=("6efa0db0e49014be7389d66af98ab7469b93fc60" "c65fd705a5c2f732b11573746926c1b6037630f2" "f80bd0721a67127e04dde4362dfcb1c39051698e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/minijail:=
	chromeos-base/metrics:=
"

RDEPEND="${COMMON_DEPEND}
	media-gfx/sane-backends:=
	media-gfx/pnm2png:=
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
	chromeos-base/system_api:=
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
