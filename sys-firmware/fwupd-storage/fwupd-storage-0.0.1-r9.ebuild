# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_COMMIT="d2d95e8af89939f893b1443135497c1f5572aebc"
CROS_WORKON_TREE="776139a53bc86333de8672a51ed7879e75909ac9"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs storage firmware update files used by fwupd."
HOMEPAGE="https://support.dell.com"
LICENSE="LVFS-Vendor-Agreement-v1"
KEYWORDS="*"
DEPEND=""
RDEPEND="sys-apps/fwupd"
IUSE="
	wilco
	skyrim
	hatch
"
declare -A dictfwcab=(
	['samsung,PM991A']='ed7ddca0c1b983a9f2f8269de7abed89492bfadba04734568f02227e42553950-Samsung_PM991a_SSD_FW_26300039.cab'
	['samsung,PM9B1-256G']='ea1dfa748eba53af904ebeebd9a8e168e08491ebeff7b98ce5ce03fd72aa8b25-SAMSUNG_PM9B1_SSD_FW_46303039.cab'
	['samsung,PM9B1-512G']='ea1dfa748eba53af904ebeebd9a8e168e08491ebeff7b98ce5ce03fd72aa8b25-SAMSUNG_PM9B1_SSD_FW_46303039.cab'
	['ssstc,CL1-3D128-Q11']='7649776aa1c1e98ca4ae99b05368135078960f1f381890532336f6229e0dc9ad-22301116.cab'
	['ssstc,CL1-3D256']='eaddc94bfa29ebc8ef2e843ac177950d11c9575c3caa5d84a31705ab1c8835e8-CR22002_428.cab'
	['ssstc,CL1-3D256-Q11']='7649776aa1c1e98ca4ae99b05368135078960f1f381890532336f6229e0dc9ad-22301116.cab'
	['ssstc,CL1-3D512-Q11']='0790e805aa3cfaf9e08b003d7aaca0b2b9988160ef8928200b869e4820fa3963-22321116.cab'
	['ssstc,CL4-3D256-Q11']='cbdb8b53779229764f678eb84236dc72dcc98af7f62e8f239c848c47d193c007-25301111.cab'
	['ssstc,CL4-3D512-Q11']='cbdb8b53779229764f678eb84236dc72dcc98af7f62e8f239c848c47d193c007-25301111.cab'
	['hynix,BC501A']='9ed8e3c35835daaea253844c678a525f1f71d02f81050763d74920283eb6eadb-Hynix_BC501A_SSD_FW_80002101.cab'
	['hynix,BC511-256G']='7ce04b003b45e9c6f612a5525b54fe51e81f205d36778b94d8db0b99c4df6fd3-Hynix_BC511_SSD_FW_11004101.cab'
	['hynix,BC511-512G']='7ce04b003b45e9c6f612a5525b54fe51e81f205d36778b94d8db0b99c4df6fd3-Hynix_BC511_SSD_FW_11004101.cab'
	['hynix,BC711-128G']='52c0c472993a5d03282efdd1b35d683c60beff4b68fdf9daaa71eadd8d8fbf54-Hynix_BC711_SSD_FW_41002131.cab'
	['hynix,BC711-256G']='52c0c472993a5d03282efdd1b35d683c60beff4b68fdf9daaa71eadd8d8fbf54-Hynix_BC711_SSD_FW_41002131.cab'
	['hynix,BC711-512G']='52c0c472993a5d03282efdd1b35d683c60beff4b68fdf9daaa71eadd8d8fbf54-Hynix_BC711_SSD_FW_41002131.cab'
	['hynix,BC901-256G']='0d680d156ae33661ec340f8c05784ec7d6b0f3fce5d635dd0f5a1adbd92892bf-LVFS_BC901_DELL_FW.cab'
	['hynix,BC901-512G']='0d680d156ae33661ec340f8c05784ec7d6b0f3fce5d635dd0f5a1adbd92892bf-LVFS_BC901_DELL_FW.cab'
	['hynix,PC601-256G']='b0b7f76ecf892c42736a7360ccb9571f784382e641bb5451b35166be2182bc91-Hynix_PC601_SSD_FW_80002111.cab'
	['hynix,PC601-512G']='b0b7f76ecf892c42736a7360ccb9571f784382e641bb5451b35166be2182bc91-Hynix_PC601_SSD_FW_80002111.cab'
	['hynix,PC601-1T']='b0b7f76ecf892c42736a7360ccb9571f784382e641bb5451b35166be2182bc91-Hynix_PC601_SSD_FW_80002111.cab'
	['wdc,SN520']='e74dffeb31030b01d8ce0299240e496641deac2fb069b153af8a5bdfcf3ef805-SN520-20240012-v1.cab'
	['wdc,SN530']='532a9ebf8ae2c8d5621efd44cc1cc30475a633760a1f42ce0fbe8de269289983-21113012_ID2409.cab'
	['wdc,SN730']='6df8d0ba1d36b3c9e017a47373c5e84f93090f80d582d7b62d1f5da0c52a5242-SN730-11121012-v1.cab'
	['wdc,SN740']='ae2a45818043417ec1bb5e84abd2d1737e2c8d351158fd437413b67df69a71ed-Vulcan_73103012.cab'
)
FILENAMES_WILCO=(
	"${dictfwcab['samsung,PM991A']}"
	"${dictfwcab['samsung,PM9B1-256G']}"
	"${dictfwcab['samsung,PM9B1-512G']}"
	"${dictfwcab['ssstc,CL1-3D128-Q11']}"
	"${dictfwcab['ssstc,CL1-3D256-Q11']}"
	"${dictfwcab['ssstc,CL1-3D512-Q11']}"
	"${dictfwcab['ssstc,CL4-3D256-Q11']}"
	"${dictfwcab['ssstc,CL4-3D512-Q11']}"
	"${dictfwcab['hynix,BC501A']}"
	"${dictfwcab['hynix,BC511-256G']}"
	"${dictfwcab['hynix,BC511-512G']}"
	"${dictfwcab['hynix,BC711-128G']}"
	"${dictfwcab['hynix,BC711-256G']}"
	"${dictfwcab['hynix,BC711-512G']}"
	"${dictfwcab['hynix,BC901-256G']}"
	"${dictfwcab['hynix,BC901-512G']}"
	"${dictfwcab['hynix,PC601-256G']}"
	"${dictfwcab['hynix,PC601-512G']}"
	"${dictfwcab['hynix,PC601-1T']}"
	"${dictfwcab['wdc,SN520']}"
	"${dictfwcab['wdc,SN530']}"
	"${dictfwcab['wdc,SN730']}"
	"${dictfwcab['wdc,SN740']}"
)
FILENAMES_SKYRIM=(
	"${dictfwcab['samsung,PM9B1-256G']}"
	"${dictfwcab['ssstc,CL4-3D256-Q11']}"
	"${dictfwcab['hynix,BC901-256G']}"
	"${dictfwcab['wdc,SN740']}"
)
# b/141010782, b/264579155: Liteon & SSSTC share the same cabinet file.
FILENAMES_HATCH=(
	"${dictfwcab['ssstc,CL1-3D256']}"
)

SRC_URI="
	wilco?  ( ${FILENAMES_WILCO[*]/#/${CROS_FWUPD_URL}/} )
	skyrim? ( ${FILENAMES_SKYRIM[*]/#/${CROS_FWUPD_URL}/} )
	hatch? ( ${FILENAMES_HATCH[*]/#/${CROS_FWUPD_URL}/} )
"
install_rules() {
	local ufile="${1}"
	[ -f "${ufile}" ] || die "File not found: ${ufile}"
	udev_dorules "${ufile}"
	einfo "Installed udev rule ${ufile}"
}
src_install() {
	# Install udev rules for automatic firmware update.
	if use wilco; then
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-hynix.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-liteon.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-samsung.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-wdc.rules"
	fi
	if use skyrim; then
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-hynix.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-liteon.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-samsung.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-wdc.rules"
	fi
	if use hatch; then
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-liteon.rules"
		install_rules "${FILESDIR}/optional/91-fwupdtool-storage-ssstc.rules"
	fi
	cros-fwupd_src_install
}
