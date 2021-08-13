# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("65599f7ca758b43b0c8658b8b364837ac782cd8b" "a8ef547c02a0645ba1704703adccfb74b4c867bf")
CROS_WORKON_TREE=("73fb751c9106f337f066c9d61b57a04de20d80c0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "f632071c623a385cb34de6a9e3344c6b7924f9e8")
CROS_WORKON_LOCALNAME=("platform2" "aosp/system/update_engine")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/system/update_engine")
CROS_WORKON_EGIT_BRANCH=("main" "master")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/update_engine")
CROS_WORKON_USE_VCSID=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="update_engine/client-headers"

inherit cros-debug cros-workon platform

DESCRIPTION="Chrome OS Update Engine client library"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/system/update_engine/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="
	!<chromeos-base/update_engine-0.0.3
"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	# Install DBus client library.
	platform_install_dbus_client_lib "update_engine"
}
