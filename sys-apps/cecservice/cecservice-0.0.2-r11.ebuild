# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v3

EAPI=7

CROS_WORKON_COMMIT="6592c7772e554b24fec10ec02b741044897fb299"
CROS_WORKON_TREE=("f6e687d95778aff2f019e7bfb54e40255774136d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "58219a041231702035f0a1dd75154637fe84671c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=("common-mk .gn cecservice")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="cecservice"

inherit cros-workon platform udev user

DESCRIPTION="ChromiumOS Consumer Electronics Control service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cecservice"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!chromeos-base/cecservice
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api
"

pkg_preinst() {
	enewuser cecservice
	enewgroup cecservice
}

src_install() {
	dosbin "${OUT}"/cecservice

	insinto /etc/init
	doins share/cecservice.conf

	insinto /etc/dbus-1/system.d
	doins share/org.chromium.CecService.conf

	insinto /usr/share/policy
	doins share/cecservice-seccomp.policy

	udev_dorules share/99-cec.rules
}

platform_pkg_test() {
	platform_test run "${OUT}"/cecservice_testrunner
}
