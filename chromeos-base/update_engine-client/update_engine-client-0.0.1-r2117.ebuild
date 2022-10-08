# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("85b14a06205ad4309c718357829421bc4706d018" "0f82eb82d1536b8cc1fec4afc42e5e9ad759a887")
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "98cd6516f771f534d81ded95faaad454de5e57a5")
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
