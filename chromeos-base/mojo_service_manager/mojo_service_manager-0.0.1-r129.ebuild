# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="9598ed0cf322a3865536a3ba7290dd19e8ae519a"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "a7ce08df7abdb46c261c18e816349ff5afc30194" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
