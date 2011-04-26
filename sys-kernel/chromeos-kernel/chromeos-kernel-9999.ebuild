# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit toolchain-funcs
inherit binutils-funcs

DESCRIPTION="Chrome OS Kernel"
HOMEPAGE="http://src.chromium.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~arm"
IUSE_KCONFIG="+kconfig_generic kconfig_atom kconfig_atom64"
IUSE="-compat_wireless -fbconsole -initramfs -nfs ${IUSE_KCONFIG}"
REQUIRED_USE="^^ ( ${IUSE_KCONFIG/+} )"
PROVIDE="virtual/kernel"

DEPEND="sys-apps/debianutils
    initramfs? ( chromeos-base/chromeos-initramfs )"
RDEPEND=""

vmlinux_text_base=${CHROMEOS_U_BOOT_VMLINUX_TEXT_BASE:-0x20008000}

# Use a single or split kernel config as specified in the board or variant
# make.conf overlay. Default to the arch specific split config if an
# overlay or variant does not set either CHROMEOS_KERNEL_CONFIG or
# CHROMEOS_KERNEL_SPLITCONFIG. CHROMEOS_KERNEL_CONFIG is set relative
# to the root of the kernel source tree.

if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
	config="${S}/${CHROMEOS_KERNEL_CONFIG}"
else
	if [ "${ARCH}" = "x86" ]; then
		config=${CHROMEOS_KERNEL_SPLITCONFIG:-"chromeos-intel-menlow"}
	else
		config=${CHROMEOS_KERNEL_SPLITCONFIG:-"chromeos-${ARCH}"}
	fi
fi

CROS_WORKON_PROJECT="kernel"
# TODO(jglasgow) Need to fix DEPS file to get rid of "files"
CROS_WORKON_LOCALNAME="../third_party/kernel/files"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon

# Allow override of kernel arch.
kernel_arch=${CHROMEOS_KERNEL_ARCH:-"$(tc-arch-kernel)"}

cross=${CHOST}-
COMPILER_OPTS=""
# Hack for using 64-bit kernel with 32-bit user-space
if [ "${ARCH}" = "x86" -a "${kernel_arch}" = "x86_64" ]; then
	cross=${CBUILD}-
else
	# TODO(raymes): Force GNU ld over gold. There are still some
	# gold issues to iron out. See: 13209.
	tc-export LD CC CXX
	COMPILER_OPTS="LD=\"$(get_binutils_path_ld)/ld\""
	COMPILER_OPTS+=" CC=\"${CC} -B$(get_binutils_path_ld)\""
	COMPILER_OPTS+=" CXX=\"${CXX} -B$(get_binutils_path_ld)\""
fi

src_configure() {
	elog "Using kernel config: ${config}"

	if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
		cp -f "${config}" "${S}"/.config || die
	else
		chromeos/scripts/prepareconfig ${config} || die
	fi

	if use fbconsole; then
		elog "   - adding framebuffer console config"
		cat "${FILESDIR}"/fbconsole.config >> "${S}"/.config
	fi

	if use nfs; then
		elog "   - adding NFS config"
		cat "${FILESDIR}"/nfs.config >> "${S}"/.config
	fi

	# Use default for any options not explitly set in splitconfig
	yes "" | eval emake ${COMPILER_OPTS} ARCH=${kernel_arch} oldconfig || die

	if use compat_wireless; then
		"${S}"/chromeos/scripts/compat_wireless_config "${S}"
	fi
}

src_compile() {
	if use initramfs; then
		INITRAMFS="CONFIG_INITRAMFS_SOURCE=${ROOT}/usr/bin/initramfs.cpio.gz"
		# We want avoid copying modules into the initramfs so we need to enable
		# the functionality required for the initramfs here.

		# TPM support to ensure proper locking.
		INITRAMFS="$INITRAMFS CONFIG_TCG_TPM=y CONFIG_TCG_TIS=y"

		# VFAT FS support for EFI System Partition updates.
		INITRAMFS="$INITRAMFS CONFIG_NLS_CODEPAGE_437=y"
		INITRAMFS="$INITRAMFS CONFIG_NLS_ISO8859_1=y"
		INITRAMFS="$INITRAMFS CONFIG_FAT_FS=y CONFIG_VFAT_FS=y"
	else
		INITRAMFS=""
	fi
	eval emake ${COMPILER_OPTS} \
		$INITRAMFS \
		ARCH=${kernel_arch} \
		CROSS_COMPILE="${cross}" || die

	if use compat_wireless; then
		# compat-wireless support must be done after
		eval emake ${COMPILER_OPTS} M=chromeos/compat-wireless \
			$INITRAMFS \
			ARCH=${kernel_arch} \
			CROSS_COMPILE="${cross}" || die
	fi
}

src_install() {
	dodir boot

	eval emake ${COMPILER_OPTS} \
		ARCH=${kernel_arch}\
		CROSS_COMPILE="${cross}" \
		INSTALL_PATH="${D}/boot" \
		install || die

	eval emake ${COMPILER_OPTS} \
		ARCH=${kernel_arch}\
		CROSS_COMPILE="${cross}" \
		INSTALL_MOD_PATH="${D}" \
		modules_install || die

	if use compat_wireless; then
		# compat-wireless modules are built+installed separately
		# NB: the updates dir is handled specially by depmod
		eval emake ${COMPILER_OPTS} M=chromeos/compat-wireless \
			ARCH=${kernel_arch}\
			CROSS_COMPILE="${cross}" \
			INSTALL_MOD_DIR=updates \
			INSTALL_MOD_PATH="${D}" \
			modules_install || die
	fi

	eval emake ${COMPILER_OPTS} \
		ARCH=${kernel_arch}\
		CROSS_COMPILE="${cross}" \
		INSTALL_MOD_PATH="${D}" \
		firmware_install || die

	if [ "${ARCH}" = "arm" ]; then
		version=$(ls "${D}"/lib/modules)

		cp -a \
			"${S}"/arch/"${ARCH}"/boot/zImage \
			"${D}/boot/vmlinuz-${version}" || die

		cp -a \
			"${S}"/System.map \
			"${D}/boot/System.map-${version}" || die

		cp -a \
			"${S}"/.config \
			"${D}/boot/config-${version}" || die

		ln -sf "vmlinuz-${version}"    "${D}"/boot/vmlinuz    || die
		ln -sf "System.map-${version}" "${D}"/boot/System.map || die
		ln -sf "config-${version}"     "${D}"/boot/config     || die

		dodir /boot

		/usr/bin/mkimage -A "${ARCH}" \
			-O linux \
			-T kernel \
			-C none \
			-a ${vmlinux_text_base} \
			-e ${vmlinux_text_base} \
			-n kernel \
			-d "${D}"/boot/vmlinuz \
			"${D}"/boot/vmlinux.uimg || die
	fi
}
