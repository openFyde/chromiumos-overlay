# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bc793c295352c5f9789bb9a7f5873c96d1349b43"
CROS_WORKON_TREE=("49ec0cc074e4fe5ad441f01547361a8f211118fa" "cfa7837a4db4f2b3340922723875f772cbf59f3b" "6e74722c57a5741908ea4eba3fb1aa495d26052b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics usb_bouncer .gn"

PLATFORM_SUBDIR="usb_bouncer"

inherit tmpfiles cros-workon platform user cros-fuzzer cros-sanitizers

DESCRIPTION="Manage the usbguard whitelist"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/usb_bouncer/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	dev-libs/openssl:0=
	sys-apps/usbguard:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/session_manager-client:="

src_install() {
	insinto /lib/udev/rules.d
	doins "${S}/40-usb-bouncer.rules"

	dotmpfiles tmpfiles.d/*.conf

	cd "${OUT}" || die
	dosbin usb_bouncer

	insinto /etc/dbus-1/system.d
	doins "${S}/UsbBouncer.conf"

	insinto /usr/share/policy
	newins "${S}/seccomp/usb_bouncer-seccomp-${ARCH}.policy" usb_bouncer-seccomp.policy

	insinto /etc/init
	doins "${S}"/init/usb_bouncer.conf

	local daemon_store="/etc/daemon-store/usb_bouncer"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners usb_bouncer:usb_bouncer "${daemon_store}"

	local f="${OUT}/usb_bouncer_fuzzer"
	fuzzer_install "${S}/OWNERS" "${f}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/run_tests"
}

pkg_setup() {
	enewuser usb_bouncer
	enewgroup usb_bouncer
	cros-workon_pkg_setup
}
