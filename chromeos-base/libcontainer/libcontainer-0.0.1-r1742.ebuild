# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="eb0846c656180dd81522e64a8fecea93b2322645"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "709a41e5e595b1ec20189cdc9912091ca7d8e048" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libcontainer .gn"

PLATFORM_SUBDIR="libcontainer"

inherit cros-workon platform user

DESCRIPTION="Library to run jailed containers on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libcontainer/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+device-mapper"

# Need lvm2 for devmapper.
RDEPEND="chromeos-base/minijail:=
	device-mapper? ( sys-fs/lvm2:= )"
DEPEND="${RDEPEND}"

src_install() {
	platform_src_install

	into /
	dolib.so "${OUT}"/lib/libcontainer.so

	"${S}"/platform2_preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libcontainer.pc

	insinto "/usr/include/chromeos"
	doins libcontainer.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}"/libcontainer_test
}
