# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53cf73a0142dfa9b267847acbb199c49d8c9f4ae"
CROS_WORKON_TREE=("6c9716db399911cdc121210cb221d310182a10f3" "ed310628c7b59ac5528ea8347990fc4f5e95c915" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libcontainer .gn"

PLATFORM_SUBDIR="libcontainer"

inherit cros-workon platform user

DESCRIPTION="Library to run jailed containers on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libcontainer/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+device-mapper"

# Need lvm2 for devmapper.
RDEPEND="chromeos-base/minijail:=
	device-mapper? ( sys-fs/lvm2:= )"
DEPEND="${RDEPEND}"

src_install() {
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
