# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="607345dc8a72c636d185349029af6b7e4642af7f"
CROS_WORKON_TREE=("bf86ccd52a8994e8c841d7b0a530173caaa5818f" "bba954637f0865ec58077edad68e4633e2d8d26e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-dbus-bindings .gn"

PLATFORM_SUBDIR="${PN}"
PLATFORM_NATIVE_TEST="yes"

inherit cros-workon platform

DESCRIPTION="Utility for building Chrome D-Bus bindings from an XML description"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-dbus-bindings"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/libbrillo:=
	dev-libs/expat
	sys-apps/dbus"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}"/generate-chromeos-dbus-bindings
}

platform_pkg_test() {
	platform_test "run" "${OUT}/chromeos_dbus_bindings_unittest"
}
