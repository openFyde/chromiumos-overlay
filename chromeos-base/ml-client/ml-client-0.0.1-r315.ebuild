# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c4b55bed1e5e021d71d42194531995f62506da9e"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "214a932db53b4a2f2718f8b6aa5c178643dab6d9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk ml .gn"

PLATFORM_SUBDIR="ml/ml-client"

inherit cros-workon platform

DESCRIPTION="ML Service D-Bus client library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/ml/"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings:=
"

src_install() {
	platform_src_install

	# Install D-Bus client library.
	platform_install_dbus_client_lib "ml"
}
