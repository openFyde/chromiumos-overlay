# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c17e88333ae74590b8e712746786ddad0a834cc8"
CROS_WORKON_TREE=("f6e687d95778aff2f019e7bfb54e40255774136d" "a0071c62ec95a11aae56ca570efdddffd0bddc54" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk sirenia .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="sirenia/manatee-client"

inherit cros-workon platform

DESCRIPTION="Chrome OS ManaTEE D-Bus client library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	chromeos-base/chromeos-dbus-bindings
"

src_install() {
	platform_src_install

	# Install D-Bus client library.
	platform_install_dbus_client_lib "manatee"
}
