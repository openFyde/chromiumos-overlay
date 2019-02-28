# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="2779be40022b1d5dfb4c23f5b414f6231427a68b"
CROS_WORKON_TREE=("8fafe4805a3e397e87abc5fd68bec0a9d23fde07" "700cb059a7acb58278736eec60959f216a595163" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk installer .gn"

PLATFORM_SUBDIR="installer"

inherit cros-workon platform systemd

DESCRIPTION="Chrome OS Installer"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_embedded cros_host -mtd pam systemd test +oobe_config"

DEPEND="
	chromeos-base/verity
	mtd? ( dev-embedded/android_mtdutils )
	!cros_host? (
		chromeos-base/vboot_reference
		dev-libs/openssl:=
	)"
RDEPEND="
	pam? ( app-admin/sudo )
	chromeos-base/chromeos-common-script
	chromeos-base/libbrillo
	!cros_host? (
		oobe_config? ( chromeos-base/oobe_config )
		dev-libs/openssl
	)
	chromeos-base/vboot_reference
	dev-util/shflags
	sys-apps/rootdev
	!cros_embedded? ( chromeos-base/chromeos-storage-info )
	sys-apps/util-linux
	sys-apps/which
	sys-fs/e2fsprogs"

platform_pkg_test() {
	platform_test "run" "${OUT}/cros_installer_test"
}

src_install() {
	if use cros_host ; then
		dosbin chromeos-install
	else
		dobin "${OUT}"/{cros_installer,cros_oobe_crypto}
		if use mtd ; then
			dobin "${OUT}"/nand_partition
		fi
		dosbin chromeos-* encrypted_import "${OUT}"/evwaitkey
		dosym usr/sbin/chromeos-postinst /postinst

		# Install init scripts.
		if use systemd; then
			systemd_dounit init/install-completed.service
			systemd_enable_service boot-services.target install-completed.service
			systemd_dounit init/crx-import.service
			systemd_enable_service system-services.target crx-import.service
		else
			insinto /etc/init
			doins init/*.conf
		fi
		exeinto /usr/share/cros/init
		doexe init/crx-import.sh
	fi
}
