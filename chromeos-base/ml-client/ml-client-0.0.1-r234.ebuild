# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6cfc665c3bc82a5b3fe209153bf75cdddd398435"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "4866bedda3e3e1309466be863d80ae5dc42ffcd3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	# Install D-Bus client library.
	platform_install_dbus_client_lib "ml"
}
