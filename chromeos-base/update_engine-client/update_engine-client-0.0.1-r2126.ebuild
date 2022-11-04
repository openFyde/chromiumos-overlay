# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("bdccaf1906d44ad449afdeafa0d4c1b6895342aa" "ce5e1112e62782a245fed3ffe03136b10d7797bd")
CROS_WORKON_TREE=("949c73de3faed1daba26b0dcf53a03f571b02837" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "655d227fed3818133103e573fb6623324f1638eb")
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
