# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c93e3d09f9b5694fe75418354b3d9305d7a84870"
CROS_WORKON_TREE=("fc0efcf57b9c4608c99ba94900299fe22d46d881" "56dc9b3a788bc68f829c1e7a1d3b6cf067c7aaf9" "ddbeeaa37f2e9ba54ba4b6c5e354766066cff22e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	dev-libs/protobuf:=
	>=net-fs/samba-4.5.3-r6
	sys-apps/dbus:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/protofiles:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/libpasswordprovider:=
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

	# fuzzer_component_id is unknown/unlisted
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
