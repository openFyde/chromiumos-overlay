# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

[[ ${EAPI} != "4" ]] && die "Only EAPI=4 is supported"

inherit binutils-funcs cros-board toolchain-funcs

HOMEPAGE="http://www.chromium.org/"
LICENSE="GPL-2"
SLOT="0"

DEPEND="sys-apps/debianutils
	chromeos-base/kernel-headers
	initramfs? ( chromeos-base/chromeos-initramfs )
"

IUSE="-device_tree -kernel_sources"
STRIP_MASK="/usr/lib/debug/boot/vmlinux"
CROS_WORKON_OUTOFTREE_BUILD=1

# Config fragments selected by USE flags
# ...fragments will have the following variables substitutions
# applied later (needs to be done later since these values
# aren't reliable when used in a global context like this):
#   %ROOT% => ${ROOT}

CONFIG_FRAGMENTS=(
	blkdevram
	fbconsole
	gdmwimax
	highmem
	initramfs
	nfs
	pcserial
	realtekpstor
	systemtap
)

blkdevram_desc="ram block device"
blkdevram_config="
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
"

fbconsole_desc="framebuffer console"
fbconsole_config="
CONFIG_FRAMEBUFFER_CONSOLE=y
"

gdmwimax_desc="GCT GDM72xx WiMAX support"
gdmwimax_config="
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_WIMAX_GDM72XX_USB_PM=y
"

highmem_desc="highmem"
highmem_config="
CONFIG_HIGHMEM64G=y
"

# We want to avoid copying modules into the initramfs so we need
# to enable the functionality required for the initramfs here.
# NOTES:
# - TPM support to ensure proper locking.
# - VFAT FS support for EFI System Partition updates.
initramfs_desc="initramfs"
initramfs_config="
CONFIG_INITRAMFS_SOURCE=\"%ROOT%/var/lib/misc/initramfs.cpio.xz\"
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_FAT_FS=y
CONFIG_VFAT_FS=y
"

nfs_desc="NFS"
nfs_config="
CONFIG_USB_NET_AX8817X=y
CONFIG_DNOTIFY=y
CONFIG_DNS_RESOLVER=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
CONFIG_NFSD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_FS=y
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V4=y
CONFIG_ROOT_NFS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_USB_USBNET=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
"

pcserial_desc="PC serial"
pcserial_config="
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
"

realtekpstor_desc="Realtek PCI card reader"
realtekpstor_config="
CONFIG_RTS_PSTOR=m
"

systemtap_desc="systemtap support"
systemtap_config="
CONFIG_KPROBES=y
CONFIG_DEBUG_INFO=y
"

# Add all config fragments as off by default
IUSE="${IUSE} ${CONFIG_FRAGMENTS[@]}"

# @FUNCTION: install_kernel_sources
# @DESCRIPTION:
# Installs the kernel sources into ${D}/usr/src/${P} and fixes symlinks.
# The package must have already installed a directory under ${D}/lib/modules.
install_kernel_sources() {
	local version=$(ls "${D}"/lib/modules)
	local dest_modules_dir=lib/modules/${version}
	local dest_source_dir=usr/src/${P}
	local dest_build_dir=${dest_source_dir}/build

	# Fix symlinks in lib/modules
	ln -sfvT "../../../${dest_build_dir}" \
	   "${D}/${dest_modules_dir}/build" || die
	ln -sfvT "../../../${dest_source_dir}" \
	   "${D}/${dest_modules_dir}/source" || die

	einfo "Installing kernel source tree"
	dodir "${dest_source_dir}"
	local f
	for f in "${S}"/*; do
		[[ "$f" == "${S}/build" ]] && continue
		cp -pPR "${f}" "${D}/${dest_source_dir}" ||
			die "Failed to copy kernel source tree"
	done

	dosym "${P}" "/usr/src/linux"

	einfo "Installing kernel build tree"
	dodir "${dest_build_dir}"
	cp -pPR "$(get_build_dir)"/{.config,.version,Makefile,Module.symvers,include} \
		"${D}/${dest_build_dir}" || die

	# Modify Makefile to use the ROOT environment variable if defined.
	# This path needs to be absolute so that the build directory will
	# still work if copied elsewhere.
	sed -i -e "s@${S}@\$(ROOT)/${dest_source_dir}@" \
		"${D}/${dest_build_dir}/Makefile" || die
}

get_build_dir() {
	echo "${WORKDIR}/${P}/build/$(get_current_board_with_variant)"
}

get_build_cfg() {
	echo "$(get_build_dir)/.config"
}

# @FUNCTION: emit_its_script
# @USAGE: <output file> <device trees>
# @DESCRIPTION:
# Emits the its script used to build the u-boot fitImage kernel binary
# that contains the kernel as well as device trees used when booting
# it.

emit_its_script() {
	local iter=1
	local its_out=${1}
	shift
	cat > "${its_out}" <<-EOF || die
	/dts-v1/;

	/ {
		description = "Chrome OS kernel image with one or more FDT blobs";
		#address-cells = <1>;

		images {
			kernel@1 {
				data = /incbin/("${boot_dir}/zImage");
				type = "$(get_kernel_type)";
				arch = "arm";
				os = "linux";
				compression = "none";
				load = <$(get_load_addr)>;
				entry = <$(get_load_addr)>;
			};
	EOF

	local dtb
	for dtb in "$@" ; do
		cat >> "${its_out}" <<-EOF || die
			fdt@${iter} {
				description = "$(basename ${dtb})";
				data = /incbin/("${boot_dir}/${dtb}");
				type = "flat_dt";
				arch = "arm";
				compression = "none";
				hash@1 {
					algo = "sha1";
				};
			};
		EOF
		((++iter))
	done

	cat <<-EOF >>"${its_script}"
		};
		configurations {
			default = "conf@1";
	EOF

	local i
	for i in $(seq 1 $((iter-1))) ; do
		cat >> "${its_out}" <<-EOF || die
			conf@${i} {
				kernel = "kernel@1";
				fdt = "fdt@${i}";
			};
		EOF
	done

	echo "	};" >> "${its_out}"
	echo "};" >> "${its_out}"
}

kmake() {
	# Allow override of kernel arch.
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}

	local cross=${CHOST}-
	# Hack for using 64-bit kernel with 32-bit user-space
	if [ "${ARCH}" = "x86" -a "${kernel_arch}" = "x86_64" ]; then
		cross=${CBUILD}-
	else
		# TODO(raymes): Force GNU ld over gold. There are still some
		# gold issues to iron out. See: 13209.
		tc-export LD CC CXX

		set -- \
			LD="$(get_binutils_path_ld)/ld" \
			CC="${CC} -B$(get_binutils_path_ld)" \
			CXX="${CXX} -B$(get_binutils_path_ld)" \
			"$@"
	fi

	emake \
		ARCH=${kernel_arch} \
		LDFLAGS="$(raw-ldflags)" \
		CROSS_COMPILE="${cross}" \
		O="$(get_build_dir)" \
		"$@"
}

cros-kernel2_src_configure() {
	mkdir -p "$(get_build_dir)"

	# Use a single or split kernel config as specified in the board or variant
	# make.conf overlay. Default to the arch specific split config if an
	# overlay or variant does not set either CHROMEOS_KERNEL_CONFIG or
	# CHROMEOS_KERNEL_SPLITCONFIG. CHROMEOS_KERNEL_CONFIG is set relative
	# to the root of the kernel source tree.
	local config
	if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
		config="${S}/${CHROMEOS_KERNEL_CONFIG}"
	else
		if [ "${ARCH}" = "x86" ]; then
			config=${CHROMEOS_KERNEL_SPLITCONFIG:-"chromiumos-i386"}
		else
			config=${CHROMEOS_KERNEL_SPLITCONFIG:-"chromiumos-${ARCH}"}
		fi
	fi

	elog "Using kernel config: ${config}"

	if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
		cp -f "${config}" "$(get_build_cfg)" || die
	else
		# TODO(30872): remove this check June 1, 2012
		# Check for stale prepareconfig.
		if [ "${PV}" = "9999" ] &&
			! grep -q outputfile chromeos/scripts/prepareconfig; then
			die "Out of date prepareconfig is not supported.\n" \
				"Please 'repo sync . && repo rebase' in:\n" \
				"${S}"
		fi
		chromeos/scripts/prepareconfig ${config} "$(get_build_cfg)" || die
	fi

	local fragment
	for fragment in ${CONFIG_FRAGMENTS[@]}; do
		use ${fragment} || continue

		local msg="${fragment}_desc"
		local config="${fragment}_config"
		elog "   - adding ${!msg} config"

		echo "${!config}" | \
			sed -e "s|%ROOT%|${ROOT}|g" \
			>> "$(get_build_cfg)" || die
	done

	# Use default for any options not explitly set in splitconfig
	yes "" | kmake oldconfig
}

get_dtb_name() {
	local board_with_variant=$(get_current_board_with_variant)

	# Do a simple mapping for device trees whose names don't match
	# the board_with_variant format; default to just the
	# board_with_variant format.
	case "${board_with_variant}" in
		(tegra2_dev-board)
			echo tegra-harmony.dtb
			;;
		(tegra2_seaboard)
			echo tegra-seaboard.dtb
			;;
		tegra*)
			echo ${board_with_variant}.dtb
			;;
		*)
			local f
			for f in $(get_build_dir)/arch/arm/boot/*.dtb ; do
			    basename ${f}
			done
			;;
	esac
}

# All current tegra boards ship with an u-boot that won't allow
# use of kernel_noload. Because of this, keep using the traditional
# kernel type for those. This means kernel_type kernel and regular
# load and entry point addresses.

get_kernel_type() {
	case "$(get_current_board_with_variant)" in
		tegra*)
			echo kernel
			;;
		*)
			echo kernel_noload
			;;
	esac
}

get_load_addr() {
	case "$(get_current_board_with_variant)" in
		tegra*)
			echo 0x03000000
			;;
		*)
			echo 0
			;;
	esac
}

cros-kernel2_src_compile() {
	local build_targets=  # use make default target
	if use arm; then
		build_targets="uImage modules"
	fi

	kmake -k ${build_targets}

	if use device_tree; then
		kmake -k dtbs
	fi
}

cros-kernel2_src_install() {
	dodir /boot
	kmake INSTALL_PATH="${D}/boot" install
	kmake INSTALL_MOD_PATH="${D}" modules_install
	kmake INSTALL_MOD_PATH="${D}" firmware_install

	local version=$(ls "${D}"/lib/modules)
	if use arm; then
		local boot_dir="$(get_build_dir)/arch/${ARCH}/boot"
		local kernel_bin="${D}/boot/vmlinuz-${version}"
		local zimage_bin="${D}/boot/zImage-${version}"
		if use device_tree; then
			local its_script="$(get_build_dir)/its_script"
			emit_its_script "${its_script}" $(get_dtb_name)
			mkimage  -f "${its_script}" "${kernel_bin}" || die
		else
			cp -a "${boot_dir}/uImage" "${kernel_bin}" || die
		fi
		cp -a "${boot_dir}/zImage" "${zimage_bin}" || die

		# TODO(vbendeb): remove the below .uimg link creation code
		# after the build scripts have been modified to use the base
		# image name.
		cd $(dirname "${kernel_bin}")
		ln -sf $(basename "${kernel_bin}") vmlinux.uimg || die
		ln -sf $(basename "${zimage_bin}") zImage || die
	fi
	if [ ! -e "${D}/boot/vmlinuz" ]; then
		ln -sf "vmlinuz-${version}" "${D}/boot/vmlinuz" || die
	fi

	# Install uncompressed kernel for debugging purposes.
	insinto /usr/lib/debug/boot
	doins "$(get_build_dir)/vmlinux"

	if use kernel_sources; then
		install_kernel_sources
	fi
}

EXPORT_FUNCTIONS src_configure src_compile src_install
