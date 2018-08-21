# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="a0f143cc50fb2fef088525e8da2fb8374427ddc8"
CROS_WORKON_TREE=("335c01060e7415af95705bf53ce03552097ba3cd" "d02359fd01e592425382457a1260b8a951a8bd8c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
IUSE="cros_embedded cros_host -mtd pam systemd test"

DEPEND="
	chromeos-base/verity
	mtd? ( dev-embedded/android_mtdutils )
	!cros_host? (
		chromeos-base/vboot_reference
		dev-libs/openssl
	)"
RDEPEND="
	pam? ( app-admin/sudo )
	chromeos-base/chromeos-common-script
	chromeos-base/libbrillo
	!cros_host? (
		chromeos-base/oobe_config
		chromeos-base/secure-erase-file
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
	platform_test "run" "${OUT}/cros_installer_unittest"
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
		# Scrubbing has to be available from non-root processes.
		mv "${D}"/usr/sbin/chromeos-saferemove "${D}"/usr/bin/ || die
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
		insinto /usr/share/cros/init
		doins init/crx-import.sh
	fi
}
