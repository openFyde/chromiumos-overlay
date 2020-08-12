# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3bc04540839db698bb914138b688c37c5964ab58"
CROS_WORKON_TREE=("769fb4f49054e9865b1f33ae4e56510f00074285" "5f87c6733a889c474220215717386858620b647a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk virtual_file_provider .gn"

PLATFORM_SUBDIR="virtual_file_provider"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide virtual file"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/virtual_file_provider"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	sys-fs/fuse:=
	sys-libs/libcap:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:="


src_install() {
	dobin "${OUT}"/virtual-file-provider
	newbin virtual-file-provider-jailed.sh virtual-file-provider-jailed

	insinto /etc/dbus-1/system.d
	doins org.chromium.VirtualFileProvider.conf

	insinto /etc/init
	doins init/virtual-file-provider.conf

	insinto /usr/share/dbus-1/system-services
	doins org.chromium.VirtualFileProvider.service
}

pkg_preinst() {
	enewuser "virtual-file-provider"
	enewgroup "virtual-file-provider"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/virtual-file-provider_testrunner"
}
