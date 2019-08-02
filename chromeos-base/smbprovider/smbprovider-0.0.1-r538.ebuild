# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="52bb12df7f36925c3913faae70581607c2f3cfc5"
CROS_WORKON_TREE=("8e516de8961c22228293b5d8bc6c23905f116abd" "c73e1f37fdaafa35e9ffaf067aca34722c2144cd" "11f1d231e13088f6dad5db5bfb3783aa62e7a6a6" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(allenvic): Remove libpasswordprovider from here once crbug.com/833675 is resolved.
CROS_WORKON_SUBTREE="common-mk libpasswordprovider smbprovider .gn"

PLATFORM_SUBDIR="smbprovider"

inherit cros-workon platform user

DESCRIPTION="Provides access to Samba file share"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smbprovider/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/protobuf:=
	>=net-fs/samba-4.5.3-r6
	sys-apps/dbus
"

DEPEND="
	${RDEPEND}
	chromeos-base/protofiles:=
	chromeos-base/system_api
	chromeos-base/libpasswordprovider
"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs smbproviderd:smbproviderd.
	enewuser "smbproviderd"
	enewgroup "smbproviderd"
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/smbproviderd

	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.SmbProvider.conf

	insinto /usr/share/dbus-1/system-services
	doins org.chromium.SmbProvider.service

	insinto /etc/init
	doins etc/init/smbproviderd.conf

	insinto /usr/share/policy
	newins seccomp_filters/smbprovider-seccomp-"${ARCH}".policy smbprovider-seccomp.policy

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/netbios_packet_fuzzer

	local daemon_store="/etc/daemon-store/smbproviderd"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners smbproviderd:smbproviderd "${daemon_store}"
}

platform_pkg_test() {
	local tests=(
		smbprovider_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
