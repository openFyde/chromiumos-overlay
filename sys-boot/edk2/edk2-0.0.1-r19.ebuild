# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Change this version number when any change is made to patches/files under
# edk2 and an auto-revbump is required.
# VERSION=REVBUMP-0.0.2

EAPI=5
CROS_WORKON_COMMIT="ab586ccd21556108662fbd80ab5a429143eac264"
CROS_WORKON_TREE="6d074f3cc9c357a209d3f0d42994cfa0579f1bbc"
CROS_WORKON_PROJECT="chromiumos/third_party/edk2"
CROS_WORKON_LOCALNAME="edk2"

inherit toolchain-funcs cros-workon coreboot-sdk multiprocessing

DESCRIPTION="EDK II firmware development environment for the UEFI and PI specifications."
HOMEPAGE="https://github.com/tianocore/edk2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="fwserial"

RDEPEND=""
DEPEND="
	sys-boot/coreboot
"

PATCHES=(
	"${FILESDIR}/00_BaseTools_Scripts.patch"
	"${FILESDIR}/01_CorebootPayloadPkg_pcinoenum.patch"
	"${FILESDIR}/02_CorebootPayloadPkg_bds.patch"
	"${FILESDIR}/03_Library_EndofDXE.patch"
	"${FILESDIR}/04_CorebootPayloadPkg_addps2.patch"
	"${FILESDIR}/06_CorebootPayloadPkg_keep_cb_table.patch"
	"${FILESDIR}/07_apics.patch"
	"${FILESDIR}/08_nvme.patch"
	"${FILESDIR}/09_nomask_8259.patch"
	"${FILESDIR}/10_eMMC.patch"
	"${FILESDIR}/11_parallel_BaseTools.patch"
	"${FILESDIR}/12_vrt.patch"
	"${FILESDIR}/13_smmstore.patch"
	"${FILESDIR}/14_Basetools_pie.patch"
	"${FILESDIR}/15_SdMMcPciHcDxe_Bayhub.patch"
	"${FILESDIR}/16_SATA_channelcount.patch"
)

BUILDTYPE=DEBUG # DEBUG or RELEASE

create_cbfs() {
	local CROS_FIRMWARE_IMAGE_DIR="/firmware"
	local CROS_FIRMWARE_ROOT="${SYSROOT%/}${CROS_FIRMWARE_IMAGE_DIR}"
	local oprom=$(echo "${CROS_FIRMWARE_ROOT}"/pci????,????.rom)
	local cbfs=tianocore.cbfs
	local bootblock="${T}/bootblock"

	_cbfstool() { set -- cbfstool "$@"; echo "$@"; "$@" || die "'$*' failed"; }
	local coreboot_rom="$(find "${CROS_FIRMWARE_ROOT}" -name coreboot.rom 2>/dev/null)"
	# Get the size of the RW_LEGACY region from the ROM
	local cbfs_size="$(_cbfstool "${coreboot_rom}" layout | sed -e "/^'RW_LEGACY'/ {s|.*size \([0-9]*\)[^0-9].*$|\1|; q}; d" )"

	# Create empty CBFS
	_cbfstool ${cbfs} create -s "${cbfs_size}" -m x86
	# Add tianocore binary to CBFS. FIXME needs newer cbfstool
	_cbfstool ${cbfs} add-payload \
			-f Build/CorebootPayloadPkgX64/${BUILDTYPE}_COREBOOT/FV/UEFIPAYLOAD.fd \
			-n payload -c lzma
	# Add VGA option rom to CBFS
	if [ -r "${oprom}" ]; then
		_cbfstool ${cbfs} add -f "${oprom}" -n $(basename "${oprom}") -t optionrom
	fi
	# Print CBFS inventory
	_cbfstool ${cbfs} print
}

src_prepare() {
	if ! use fwserial; then
		PATCHES+=("${FILESDIR}/05_CorebootPayloadPkg_noserial.patch")
	fi

	epatch "${PATCHES[@]}"
}

src_compile() {
	. ./edksetup.sh
	cat /opt/coreboot-sdk/share/edk2config/tools_def.txt \
		>> Conf/tools_def.txt
	( cd BaseTools/Source/C && emake ARCH=X64 )
	export COREBOOT_SDK_PREFIX_arm COREBOOT_SDK_PREFIX_arm64 COREBOOT_SDK_PREFIX_x86_32 COREBOOT_SDK_PREFIX_x86_64
	build -t COREBOOT -a IA32 -a X64 -b ${BUILDTYPE} -n $(makeopts_jobs) \
			-p CorebootPayloadPkg/CorebootPayloadPkgIa32X64.dsc
	create_cbfs
}

src_install() {
	insinto /firmware
	doins tianocore.cbfs
}
