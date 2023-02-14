# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "5320415a50935ec2dfc2775f4fc11d9729390b52" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
