# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="2e5c421c335d5e5750149a486d4b63bc5e158517"
CROS_WORKON_TREE=("beaa23ddfa8fcd0c80807667abfa09780522b3ad" "211af3899694db591452b8e94dcb99972a902776" "0b7c560dff3dc08909ca5e65d32968d18f797652" "f377301bc2e2549e83f69b66e7de156cf68d5d79" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
PACKAGE_SUBDIR="mojo_service_manager/BUILD.gn mojo_service_manager/daemon mojo_service_manager/lib"
CROS_WORKON_SUBTREE="common-mk ${PACKAGE_SUBDIR} .gn"
PLATFORM_SUBDIR="mojo_service_manager"

inherit cros-workon platform user

DESCRIPTION="Daemon to manage mojo interfaces"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mojo_service_manager/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	enewuser mojo-service-manager
	enewgroup mojo-service-manager
}

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
