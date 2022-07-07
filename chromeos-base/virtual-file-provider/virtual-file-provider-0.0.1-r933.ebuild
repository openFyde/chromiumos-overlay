# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6c7e50d91c3cd4c58751084ba660d0e34b5814d6"
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "fc293354fb8ad9a9192d7ebfab15a03e8f0799ba" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk virtual_file_provider .gn"

PLATFORM_SUBDIR="virtual_file_provider"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide virtual file"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/virtual_file_provider"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="arcvm"

RDEPEND="
	sys-fs/fuse:=
	sys-libs/libcap:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:="


src_install() {
	dobin "${OUT}"/virtual-file-provider
	if use arcvm; then
		newbin virtual-file-provider-jailed-arcvm.sh virtual-file-provider-jailed
	else
		newbin virtual-file-provider-jailed.sh virtual-file-provider-jailed
	fi

	insinto /etc/dbus-1/system.d
	doins org.chromium.VirtualFileProvider.conf

	insinto /etc/init
	doins init/virtual-file-provider.conf
	doins init/virtual-file-provider-cgroup.conf

	insinto /usr/share/power_manager
	doins powerd_prefs/suspend_freezer_deps_virtual-file-provider
}

pkg_preinst() {
	enewuser "virtual-file-provider"
	enewgroup "virtual-file-provider"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/virtual-file-provider_testrunner"
}
