# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs storage firmware update files used by fwupd."
HOMEPAGE="https://support.dell.com"
LICENSE="LVFS-Vendor-Agreement-v1"
KEYWORDS="~*"
DEPEND=""
RDEPEND="sys-apps/fwupd"
IUSE="
	wilco
"
FILENAMES_WILCO=(
	# Samsung PM991a
	"ed7ddca0c1b983a9f2f8269de7abed89492bfadba04734568f02227e42553950-Samsung_PM991a_SSD_FW_26300039.cab"
	# SSSTC CL1-3D128-Q11, CL1-3D256-Q11
	"7649776aa1c1e98ca4ae99b05368135078960f1f381890532336f6229e0dc9ad-22301116.cab"
	# SSSTC CL1-3D512-Q11
	"0790e805aa3cfaf9e08b003d7aaca0b2b9988160ef8928200b869e4820fa3963-22321116.cab"
	# SSSTC CL4-3D256-Q11, CL4-3D512-Q11
	"f0ac0e20299c3cddd028d63149fce39b7a152c69d1819d20011c745d6c975cd8-25301111.cab"
	# Hynix BC501A
	"9ed8e3c35835daaea253844c678a525f1f71d02f81050763d74920283eb6eadb-Hynix_BC501A_SSD_FW_80002101.cab"
	# Hynix BC511 256G/512G
	"7ce04b003b45e9c6f612a5525b54fe51e81f205d36778b94d8db0b99c4df6fd3-Hynix_BC511_SSD_FW_11004101.cab"
	# Hynix BC711 128G/256G/512G
	"52c0c472993a5d03282efdd1b35d683c60beff4b68fdf9daaa71eadd8d8fbf54-Hynix_BC711_SSD_FW_41002131.cab"
	# Hynix PC601 256G/512G/1T
	"b0b7f76ecf892c42736a7360ccb9571f784382e641bb5451b35166be2182bc91-Hynix_PC601_SSD_FW_80002111.cab"
	# WDC SN520
	"e74dffeb31030b01d8ce0299240e496641deac2fb069b153af8a5bdfcf3ef805-SN520-20240012-v1.cab"
	# WDC SN530
	"532a9ebf8ae2c8d5621efd44cc1cc30475a633760a1f42ce0fbe8de269289983-21113012_ID2409.cab"
	# WDC SN730
	"6df8d0ba1d36b3c9e017a47373c5e84f93090f80d582d7b62d1f5da0c52a5242-SN730-11121012-v1.cab"
	# WDC SN740
	"ae2a45818043417ec1bb5e84abd2d1737e2c8d351158fd437413b67df69a71ed-Vulcan_73103012.cab"
)
SRC_URI="
	wilco? ( ${FILENAMES_WILCO[*]/#/${CROS_FWUPD_URL}/} )
"
install_rules() {
	local srcdir="${1}"
	[ -e "${srcdir}" ] || die "File not found: ${srcdir}"
	while read -d $'\0' -r file; do
		udev_dorules "${file}"
		einfo "Installed udev rule ${file}"
	done < <(find -H "${srcdir}" -name "*.rules" -maxdepth 1 -mindepth 1 -print0)
}
src_install() {
	# Install udev rules for automatic firmware update.
	if use wilco; then
		install_rules "${FILESDIR}/wilco"
	fi
	cros-fwupd_src_install
}
