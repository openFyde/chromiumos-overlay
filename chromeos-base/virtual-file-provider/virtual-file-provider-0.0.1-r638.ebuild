# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9e62cfe40b0d3899cbab3220cdc59c656cbc082f"
CROS_WORKON_TREE=("f175d005c6acb682187ad75972eeef05a093f939" "ed7c4a0f6ea65a659fc5e3e957ef32f3659d33fc" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	sys-fs/fuse
	sys-libs/libcap
"

DEPEND="${RDEPEND}
	chromeos-base/system_api"


src_install() {
	dobin "${OUT}"/virtual-file-provider
	newbin virtual-file-provider-jailed.sh virtual-file-provider-jailed

	insinto /etc/dbus-1/system.d
	doins org.chromium.VirtualFileProvider.conf

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
