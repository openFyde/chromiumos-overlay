# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="imageloader"
PLATFORM_GYP_FILE="imageloader-client.gyp"

inherit cros-workon platform

DESCRIPTION="ImageLoader DBus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/imageloader/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="cros_host"

# D-Bus proxies generated by this client library depend on the code generator
# itself (chromeos-dbus-bindings) and produce header files that rely on
# libbrillo library.
DEPEND="
	cros_host? ( chromeos-base/chromeos-dbus-bindings )
	chromeos-base/libbrillo
"

RDEPEND="
	chromeos-base/imageloader
"

src_install() {
	# Install DBus client library.
	platform_install_dbus_client_lib "imageloader"
}
