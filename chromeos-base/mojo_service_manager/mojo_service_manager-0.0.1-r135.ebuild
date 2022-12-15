# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="d9b35688d673fc3df047212a2ba0056d35870b95"
CROS_WORKON_TREE=("232eeac462515f4e1460770a38b8ac52bef0adec" "478fda65401c49d9a8814ddd694a79ed5e1ba4f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk mojo_service_manager .gn"
PLATFORM_SUBDIR="mojo_service_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage mojo interfaces"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mojo_service_manager/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/system_api
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	enewuser mojo-service-manager
	enewgroup mojo-service-manager
}

platform_pkg_test() {
	platform test_all
}
