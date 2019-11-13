# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Check for EAPI 4+
case "${EAPI:-0}" in
0|1|2|3) die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}" ;;
*) ;;
esac

# Since we use CHROMEOS_KERNEL_CONFIG and CHROMEOS_KERNEL_SPLITCONFIG here,
# it is not safe to reuse the kernel prebuilts across different boards. Inherit
# the cros-board eclass to make sure that doesn't happen.
inherit binutils-funcs cros-board toolchain-funcs versionator

HOMEPAGE="http://www.chromium.org/"
LICENSE="GPL-2"
SLOT="0"

DEPEND="sys-apps/debianutils
	sys-kernel/linux-firmware
	factory_netboot_ramfs? ( chromeos-base/chromeos-initramfs[factory_netboot_ramfs] )
	factory_shim_ramfs? ( chromeos-base/chromeos-initramfs[factory_shim_ramfs] )
	recovery_ramfs? ( chromeos-base/chromeos-initramfs[recovery_ramfs] )
	builtin_fw_t210_nouveau? ( sys-kernel/nouveau-firmware )
	builtin_fw_t210_bpmp? ( sys-kernel/tegra_bpmp-t210 )
	builtin_fw_x86_aml_ucode? ( chromeos-base/aml-ucode-firmware-private )
	builtin_fw_x86_apl_ucode? ( chromeos-base/apl-ucode-firmware-private )
	builtin_fw_x86_bdw_ucode? ( chromeos-base/bdw-ucode-firmware-private )
	builtin_fw_x86_bsw_ucode? ( chromeos-base/bsw-ucode-firmware-private )
	builtin_fw_x86_byt_ucode? ( chromeos-base/byt-ucode-firmware-private )
	builtin_fw_x86_glk_ucode? ( chromeos-base/glk-ucode-firmware-private )
	builtin_fw_x86_kbl_ucode? ( chromeos-base/kbl-ucode-firmware-private )
	builtin_fw_x86_skl_ucode? ( chromeos-base/skl-ucode-firmware-private )
	builtin_fw_x86_whl_ucode? ( chromeos-base/whl-ucode-firmware-private )
"

WIRELESS_VERSIONS=( 3.4 3.8 3.18 4.2 )
WIRELESS_SUFFIXES=( ${WIRELESS_VERSIONS[@]/.} )

IUSE="
	apply_patches
	-asan
	buildtest
	+clang
	-compilation_database
	-device_tree
	+dt_compression
	+fit_compression_kernel_lz4
	fit_compression_kernel_lzma
	firmware_install
	-kernel_sources
	lld
	nfc
	${WIRELESS_SUFFIXES[@]/#/-wireless}
	-wifi_testbed_ap
	-boot_dts_device_tree
	-nowerror
	-ppp
	-lxc
	-binder
	-selinux_develop
	-transparent_hugepage
	tpm2
	-kernel_afdo
	test
	-criu
"
REQUIRED_USE="
	compilation_database? ( clang )
	fit_compression_kernel_lz4? ( !fit_compression_kernel_lzma )
	fit_compression_kernel_lzma? ( !fit_compression_kernel_lz4 )
	lld? ( clang )
"
STRIP_MASK="
	/lib/modules/*/kernel/*
	/usr/lib/debug/boot/vmlinux
	/usr/lib/debug/lib/modules/*
	/usr/src/*
"

# SRC_URI requires RESTRICT="mirror". We specify AutoFDO profiles in SRC_URI
# so that ebuild can fetch it for us.
RESTRICT="mirror"
SRC_URI=""

KERNEL_VERSION="${PN#chromeos-kernel-}"
KERNEL_VERSION="${KERNEL_VERSION/_/.}"

# Specifying AutoFDO profiles in SRC_URI and let ebuild fetch it for us.
# Prefer the frozen version of afdo profiles if set.
AFDO_VERSION=${AFDO_FROZEN_PROFILE_VERSION:-$AFDO_PROFILE_VERSION}
if [[ -n "${AFDO_VERSION}" ]]; then
	AFDO_LOCATION="gs://chromeos-prebuilt/afdo-job/cwp/kernel/${KERNEL_VERSION}"
	AFDO_GCOV="${PN}-${AFDO_VERSION}.gcov"
	AFDO_GCOV_COMPBINARY="${AFDO_GCOV}.compbinary.afdo"
	SRC_URI+="
		kernel_afdo? ( ${AFDO_LOCATION}/${AFDO_VERSION}.gcov.xz -> ${AFDO_GCOV}.xz )
	"
fi

apply_private_patches() {
	eshopts_push -s nullglob
	local patches=( "${FILESDIR}"/*.patch )
	eshopts_pop
	[[ ${#patches[@]} -gt 0 ]] && epatch "${patches[@]}"
}

# Ignore files under /lib/modules/ as we like to install vdso objects in there.
MULTILIB_STRICT_EXEMPT+="|modules"

# Build out-of-tree and incremental by default, but allow an ebuild inheriting
# this eclass to explicitly build in-tree.
: ${CROS_WORKON_OUTOFTREE_BUILD:=1}
: ${CROS_WORKON_INCREMENTAL_BUILD:=1}

# Config fragments selected by USE flags. _config fragments are mandatory,
# _config_disable fragments are optional and will be appended to kernel config
# if use flag is not set.
# ...fragments will have the following variables substitutions
# applied later (needs to be done later since these values
# aren't reliable when used in a global context like this):
#   %ROOT% => ${SYSROOT}

CONFIG_FRAGMENTS=(
	acpi_ac
	allocator_slab
	apex
	binder
	blkdevram
	bt_unsupported_read_enc_key_size
	ca0132
	cec
	criu
	cros_ec_mec
	debug
	debugobjects
	devdebug
	diskswap
	dmadebug
	dm_snapshot
	dp_cec
	drm_dp_aux_chardev
	dwc2_dual_role
	dyndebug
	eve_bt_hacks
	eve_wifi_etsi
	factory_netboot_ramfs
	factory_shim_ramfs
	failslab
	fbconsole
	goldfish
	highmem
	hypervisor_guest
	i2cdev
	iscsi
	kasan
	kcov
	kernel_compress_xz
	kexec_file
	kgdb
	kmemleak
	kvm
	kvm_host
	kvm_nested
	lockdebug
	lxc
	mbim
	memory_debug
	module_sign
	nfc
	nfs
	nowerror
	pca954x
	pcserial
	plan9
	ppp
	pvrdebug
	qmi
	realtekpstor
	recovery_ramfs
	samsung_serial
	selinux_develop
	socketmon
	systemtap
	tpm
	transparent_hugepage
	ubsan
	usb_gadget
	usb_gadget_acm
	usb_gadget_audio
	usb_gadget_ncm
	usbip
	vfat
	virtio_balloon
	vivid
	vlan
	vtconsole
	wifi_testbed_ap
	wifi_diag
	wireless34
	x32
)

acpi_ac_desc="Enable ACPI AC"
acpi_ac_config="
CONFIG_ACPI_AC=y
"
acpi_ac_config_disable="
# CONFIG_ACPI_AC is not set
"

allocator_slab_desc="Turn on SLAB allocator"
allocator_slab_config="
CONFIG_SLAB=y
# CONFIG_SLUB is not set
"

apex_desc="Apex chip kernel driver"
apex_config="
CONFIG_STAGING_GASKET_FRAMEWORK=m
CONFIG_STAGING_APEX_DRIVER=m
"

binder_desc="binder IPC"
binder_config="
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
"

blkdevram_desc="ram block device"
blkdevram_config="
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
"

bt_unsupported_read_enc_key_size_desc="Disable BT Classic security enforcement"
bt_unsupported_read_enc_key_size_config="
CONFIG_BT_ENFORCE_CLASSIC_SECURITY=n
"

ca0132_desc="CA0132 ALSA codec"
ca0132_config="
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_DSP_LOADER=y
"

cec_desc="Consumer Electronics Control support"
cec_config="
CONFIG_CEC_CORE=y
CONFIG_MEDIA_CEC_SUPPORT=y
"

criu_desc="Flags required if you wish to use the criu python library"
criu_config="
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_EPOLL=y
CONFIG_EVENTFD=y
CONFIG_FHANDLE=y
CONFIG_IA32_EMULATION=y
CONFIG_INET_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INOTIFY_USER=y
CONFIG_NAMESPACES=y
CONFIG_NETLINK_DIAG=y
CONFIG_PACKET_DIAG=y
CONFIG_PID_NS=y
CONFIG_UNIX_DIAG=y
"

cros_ec_mec_desc="LPC Support for Microchip Embedded Controller"
cros_ec_mec_config="
CONFIG_MFD_CROS_EC_LPC_MEC=y
CONFIG_CROS_EC_LPC_MEC=y
"

debugobjects_desc="Enable kernel debug objects debugging"
debugobjects_config="
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
"

# devdebug configuration options should impose no or little runtime
# overhead while providing useful information for developers.
devdebug_desc="Miscellaneous developer debugging options"
devdebug_config="
CONFIG_ARM_PTDUMP=y
CONFIG_ARM_PTDUMP_DEBUGFS=y
CONFIG_ARM64_PTDUMP_DEBUGFS=y
CONFIG_BLK_DEBUG_FS=y
CONFIG_DEBUG_DEVRES=y
CONFIG_DEBUG_WX=y
CONFIG_GENERIC_IRQ_DEBUGFS=y
CONFIG_IRQ_DOMAIN_DEBUG=y
"

diskswap_desc="Enable swap file"
diskswap_config="
CONFIG_CRYPTO_LZO=y
CONFIG_DISK_BASED_SWAP=y
CONFIG_FRONTSWAP=y
CONFIG_LZO_COMPRESS=y
CONFIG_Z3FOLD=y
CONFIG_ZBUD=y
CONFIG_ZPOOL=y
CONFIG_ZSWAP=y
"

dmadebug_desc="Enable DMA debugging"
dmadebug_config="
CONFIG_DMA_API_DEBUG=y
"

dm_snapshot_desc="Snapshot device mapper target"
dm_snapshot_config="
CONFIG_BLK_DEV_DM=y
CONFIG_DM_SNAPSHOT=m
"

dp_cec_desc="DisplayPort CEC-Tunneling-over-AUX support"
dp_cec_config="
CONFIG_DRM_DP_CEC=y
"

drm_dp_aux_chardev_desc="DisplayPort DP AUX driver support"
drm_dp_aux_chardev_config="
CONFIG_DRM_DP_AUX_CHARDEV=y
"

dwc2_dual_role_desc="Dual Role support for DesignWare USB2.0 controller"
dwc2_dual_role_config="
CONFIG_USB_DWC2_DUAL_ROLE=y
"

dyndebug_desc="Enable Dynamic Debug"
dyndebug_config="
CONFIG_DYNAMIC_DEBUG=y
"

eve_bt_hacks_desc="Enable Bluetooth Hacks for Eve"
eve_bt_hacks_config="
CONFIG_BT_EVE_HACKS=y
"

eve_wifi_etsi_desc="Eve-specific workaround for ETSI"
eve_wifi_etsi_config="
CONFIG_EVE_ETSI_WORKAROUND=y
"

failslab_desc="Enable fault injection"
failslab_config="
CONFIG_FAILSLAB=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
"

fbconsole_desc="framebuffer console"
fbconsole_config="
CONFIG_FRAMEBUFFER_CONSOLE=y
"
fbconsole_config_disable="
# CONFIG_FRAMEBUFFER_CONSOLE is not set
"

goldfish_dec="Goldfish virtual hardware platform"
goldfish_config="
CONFIG_GOLDFISH=y
CONFIG_GOLDFISH_BUS=y
CONFIG_GOLDFISH_PIPE=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
"

highmem_desc="highmem"
highmem_config="
CONFIG_HIGHMEM64G=y
"

hypervisor_guest_desc="Support running under a hypervisor"
hypervisor_guest_config="
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_KVM_GUEST=y
"

i2cdev_desc="I2C device interface"
i2cdev_config="
CONFIG_I2C_CHARDEV=y
"

iscsi_desc="iSCSI initiator and target drivers"
iscsi_config="
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_CONFIGFS_FS=m
CONFIG_TARGET_CORE=m
CONFIG_ISCSI_TARGET=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
"

kasan_desc="Enable KASAN"
kasan_config="
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y
CONFIG_TEST_KASAN=m
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_FRAME_WARN=0
"

kcov_desc="Enable kcov"
kcov_config="
CONFIG_KCOV=y
# CONFIG_RANDOMIZE_BASE is not set
"

kernel_compress_xz_desc="Compresss kernel image with XZ"
kernel_compress_xz_config="
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_KERNEL_XZ=y
"

kexec_file_desc="Enable CONFIG_KEXEC_FILE"
kexec_file_config="
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
# CONFIG_KEXEC is not set
CONFIG_KEXEC_FILE=y
# CONFIG_KEXEC_VERIFY_SIG is not set
"

kgdb_desc="Enable kgdb"
kgdb_config="
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_INFO=y
CONFIG_FRAME_POINTER=y
CONFIG_GDB_SCRIPTS=y
CONFIG_KGDB=y
CONFIG_KGDB_KDB=y
CONFIG_PANIC_TIMEOUT=0
# CONFIG_RANDOMIZE_BASE is not set
# CONFIG_WATCHDOG is not set
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=1
CONFIG_DEBUG_INFO_DWARF4=y
"""
# kgdb over serial port depends on CONFIG_HW_CONSOLE which depends on CONFIG_VT
REQUIRED_USE="${REQUIRED_USE} kgdb? ( vtconsole )"

kmemleak_desc="Enable kmemleak"
kmemleak_config="
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=16384
"

lockdebug_desc="Additional lock debug settings"
lockdebug_config="
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_LOCKING=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
"

nfc_desc="Enable NFC support"
nfc_config="
CONFIG_NFC=m
CONFIG_NFC_HCI=m
CONFIG_NFC_LLCP=y
CONFIG_NFC_NCI=m
CONFIG_NFC_PN533=m
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_SHDLC=y
"

pvrdebug_desc="PowerVR Rogue debugging"
pvrdebug_config="
CONFIG_DRM_POWERVR_ROGUE_DEBUG=y
"

tpm_desc="TPM support"
tpm_config="
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
"

recovery_ramfs_desc="Initramfs for recovery image"
recovery_ramfs_config='
CONFIG_INITRAMFS_SOURCE="%ROOT%/var/lib/initramfs/recovery_ramfs.cpio.xz"
CONFIG_INITRAMFS_COMPRESSION_XZ=y
'

factory_netboot_ramfs_desc="Initramfs for factory netboot installer"
factory_netboot_ramfs_config='
CONFIG_INITRAMFS_SOURCE="%ROOT%/var/lib/initramfs/factory_netboot_ramfs.cpio.xz"
CONFIG_INITRAMFS_COMPRESSION_XZ=y
'

factory_shim_ramfs_desc="Initramfs for factory installer shim"
factory_shim_ramfs_config='
CONFIG_INITRAMFS_SOURCE="%ROOT%/var/lib/initramfs/factory_shim_ramfs.cpio.xz"
CONFIG_INITRAMFS_COMPRESSION_XZ=y
'

vfat_desc="vfat"
vfat_config="
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_FAT_FS=y
CONFIG_VFAT_FS=y
"

kvm_desc="KVM"
kvm_config="
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_BLK=m
CONFIG_VIRTIO_NET=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTUALIZATION=y
"

kvm_host_desc="Support running virtual machines with KVM"
kvm_host_config="
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_KVM=y
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_KVM_APIC_ARCHITECTURE is not set
# CONFIG_KVM_ASYNC_PF is not set
CONFIG_KVM_AMD=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_MMIO=y
CONFIG_VSOCKETS=m
CONFIG_VHOST_VSOCK=m
CONFIG_VIRTUALIZATION=y
CONFIG_KVM_ARM_HOST=y
"

kvm_nested_desc="Support running nested VMs"
kvm_nested_config="
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_KVM=y
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_KVM_APIC_ARCHITECTURE is not set
# CONFIG_KVM_ASYNC_PF is not set
CONFIG_KVM_AMD=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_MMIO=y
"

# TODO(benchan): Remove the 'mbim' use flag and unconditionally enable the
# CDC MBIM driver once Chromium OS fully supports MBIM.
mbim_desc="CDC MBIM driver"
mbim_config="
CONFIG_USB_NET_CDC_MBIM=m
"

memory_debug_desc="Memory debugging"
memory_debug_config="
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_PGFLAGS=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_POISONING=y
"

module_sign_desc="Enable kernel module signing and signature verification"
module_sign_config='
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_ASN1=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_RSA=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS="certs/trusted_key.pem"
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
CONFIG_SECONDARY_TRUSTED_KEYRING=y
CONFIG_CLZ_TAB=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
'

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

pca954x_desc="PCA954x I2C mux"
pca954x_config="
CONFIG_I2C_MUX_PCA954x=m
"

pcserial_desc="PC serial"
pcserial_config="
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_EARLYCON=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
"

plan9_desc="Plan 9 protocol support"
plan9_config="
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
"

ppp_desc="PPPoE and ppp support"
ppp_config="
CONFIG_PPPOE=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_MPPE=m
CONFIG_PPP_SYNC_TTY=m
"

qmi_desc="QMI WWAN driver"
qmi_config="
CONFIG_USB_NET_QMI_WWAN=m
"

realtekpstor_desc="Realtek PCI card reader"
realtekpstor_config="
CONFIG_RTS_PSTOR=m
"

samsung_serial_desc="Samsung serialport"
samsung_serial_config="
CONFIG_SERIAL_SAMSUNG=y
CONFIG_SERIAL_SAMSUNG_CONSOLE=y
"

selinux_develop_desc="SELinux developer mode"
selinux_develop_config="
# CONFIG_SECURITY_SELINUX_PERMISSIVE_DONTAUDIT is not set
"

socketmon_desc="INET socket monitoring interface (for iproute2 ss)"
socketmon_config="
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
"

systemtap_desc="systemtap support"
systemtap_config="
CONFIG_KPROBES=y
CONFIG_DEBUG_INFO=y
"

ubsan_desc="Enable UBSAN"
ubsan_config="
CONFIG_UBSAN=y
CONFIG_UBSAN_SANITIZE_ALL=y
CONFIG_TEST_UBSAN=m
"

usb_gadget_desc="USB gadget support with ConfigFS/FunctionFS"
usb_gadget_config="
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_F_FS=y
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_GADGET=y
"

usb_gadget_acm_desc="USB ACM gadget support"
usb_gadget_acm_config="
CONFIG_USB_CONFIGFS_ACM=y
"

usb_gadget_audio_desc="USB Audio gadget support"
usb_gadget_audio_config="
CONFIG_USB_CONFIGFS_F_UAC1=y
CONFIG_USB_CONFIGFS_F_UAC2=y
"

usb_gadget_ncm_desc="USB NCM gadget support"
usb_gadget_ncm_config="
CONFIG_USB_CONFIGFS_NCM=y
"

usbip_desc="Virtual USB support"
usbip_config="
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
"

virtio_balloon_desc="Balloon driver support kvm guests"
virtio_balloon_config="
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_VIRTIO_BALLOON=m
"

vivid_desc="Virtual Video Test Driver"
vivid_config="
CONFIG_VIDEO_VIVID=m
CONFIG_VIDEO_VIVID_MAX_DEVS=64
"

vlan_desc="802.1Q VLAN"
vlan_config="
CONFIG_VLAN_8021Q=m
"

wifi_testbed_ap_desc="Defer Atheros Wifi EEPROM regulatory"
wifi_testbed_ap_warning="
Don't use the wifi_testbed_ap flag unless you know what you are doing!
An image built with this flag set must never be run outside a
sealed RF chamber!
"
wifi_testbed_ap_config="
CONFIG_ATH_DEFER_EEPROM_REGULATORY=y
CONFIG_BRIDGE=y
CONFIG_MAC80211_BEACON_FOOTER=y
"

wifi_diag_desc="mac80211 WiFi diagnostic support"
wifi_diag_config="
CONFIG_MAC80211_WIFI_DIAG=y
"

x32_desc="x32 ABI support"
x32_config="
CONFIG_X86_X32=y
"

wireless34_desc="Wireless 3.4 stack"
wireless34_config="
CONFIG_ATH9K_BTCOEX=m
CONFIG_ATH9K_BTCOEX_COMMON=m
CONFIG_ATH9K_BTCOEX_HW=m
"

vtconsole_desc="VT console"
vtconsole_config="
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
"
vtconsole_config_disable="
# CONFIG_VT is not set
# CONFIG_VT_CONSOLE is not set
"

nowerror_desc="Don't build with -Werror (warnings aren't fatal)."
nowerror_config="
# CONFIG_ERROR_ON_WARNING is not set
"

lxc_desc="LXC Support (Linux Containers)"
lxc_config="
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_MACVLAN=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_SECURITY_CHROMIUMOS_NO_SYMLINK_MOUNT=n
CONFIG_OVERLAY_FS=m
"

transparent_hugepage_desc="Transparent Hugepage Support"
transparent_hugepage_config="
CONFIG_ARM_LPAE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
"

# We blast in all the debug options we can under this use flag so we can catch
# as many kernel bugs as possible in testing. Developers can choose to use
# this option too, but they should expect performance to be degraded, unlike
# the devdebug use flag. Since the kernel binary in gzip may be too large to
# fit into a typical 16MB partition, we also switch to xz compression.
debug_desc="All the debug options to catch kernel bugs in testing configurations"
debug_config="
${debugobjects_config}
${devdebug_config}
${dmadebug_config}
${dyndebug_config}
${kasan_config}
${kernel_compress_xz_config}
${lockdebug_config}
${memory_debug_config}
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_WQ_WATCHDOG=y
"

# Firmware binaries selected by USE flags.  Selected firmware binaries will
# be built into the kernel using CONFIG_EXTRA_FIRMWARE.

FIRMWARE_BINARIES=(
	builtin_fw_amdgpu
	builtin_fw_t124_xusb
	builtin_fw_t210_xusb
	builtin_fw_t210_nouveau
	builtin_fw_t210_bpmp
	builtin_fw_guc_g9
	builtin_fw_huc_g9
	builtin_fw_x86_aml_ucode
	builtin_fw_x86_apl_ucode
	builtin_fw_x86_bdw_ucode
	builtin_fw_x86_bsw_ucode
	builtin_fw_x86_byt_ucode
	builtin_fw_x86_glk_ucode
	builtin_fw_x86_kbl_ucode
	builtin_fw_x86_skl_ucode
	builtin_fw_x86_whl_ucode
)

builtin_fw_amdgpu_desc="Firmware for AMD GPU"
builtin_fw_amdgpu_files=(
	amdgpu/carrizo_ce.bin
	amdgpu/carrizo_me.bin
	amdgpu/carrizo_mec.bin
	amdgpu/carrizo_mec2.bin
	amdgpu/carrizo_pfp.bin
	amdgpu/carrizo_rlc.bin
	amdgpu/carrizo_sdma.bin
	amdgpu/carrizo_sdma1.bin
	amdgpu/carrizo_uvd.bin
	amdgpu/carrizo_vce.bin
	amdgpu/picasso_asd.bin
	amdgpu/picasso_ce.bin
	amdgpu/picasso_gpu_info.bin
	amdgpu/picasso_me.bin
	amdgpu/picasso_mec2.bin
	amdgpu/picasso_mec.bin
	amdgpu/picasso_pfp.bin
	amdgpu/picasso_rlc_am4.bin
	amdgpu/picasso_rlc.bin
	amdgpu/picasso_sdma.bin
	amdgpu/picasso_vcn.bin
	amdgpu/raven_dmcu.bin
	amdgpu/raven2_asd.bin
	amdgpu/raven2_ce.bin
	amdgpu/raven2_gpu_info.bin
	amdgpu/raven2_me.bin
	amdgpu/raven2_mec.bin
	amdgpu/raven2_mec2.bin
	amdgpu/raven2_pfp.bin
	amdgpu/raven2_rlc.bin
	amdgpu/raven2_sdma.bin
	amdgpu/raven2_vcn.bin
	amdgpu/stoney_ce.bin
	amdgpu/stoney_me.bin
	amdgpu/stoney_mec.bin
	amdgpu/stoney_pfp.bin
	amdgpu/stoney_rlc.bin
	amdgpu/stoney_sdma.bin
	amdgpu/stoney_uvd.bin
	amdgpu/stoney_vce.bin
)

builtin_fw_t124_xusb_desc="Tegra124 XHCI controller"
builtin_fw_t124_xusb_files=(
	nvidia/tegra124/xusb.bin
)

builtin_fw_t210_xusb_desc="Tegra210 XHCI controller"
builtin_fw_t210_xusb_files=(
	nvidia/tegra210/xusb.bin
)

builtin_fw_t210_nouveau_desc="Tegra210 Nouveau GPU"
builtin_fw_t210_nouveau_files=(
	nouveau/acr_ucode.bin
	nouveau/fecs.bin
	nouveau/fecs_sig.bin
	nouveau/gpmu_ucode_desc.bin
	nouveau/gpmu_ucode_image.bin
	nouveau/nv12b_bundle
	nouveau/nv12b_fuc409c
	nouveau/nv12b_fuc409d
	nouveau/nv12b_fuc41ac
	nouveau/nv12b_fuc41ad
	nouveau/nv12b_method
	nouveau/nv12b_sw_ctx
	nouveau/nv12b_sw_nonctx
	nouveau/pmu_bl.bin
	nouveau/pmu_sig.bin
)

builtin_fw_t210_bpmp_desc="Tegra210 BPMP"
builtin_fw_t210_bpmp_files=(
	nvidia/tegra210/bpmp.bin
)

builtin_fw_guc_g9_desc="GuC Firmware for Gen9"
builtin_fw_guc_g9_files=(
	i915/kbl_guc_ver9_39.bin
)

builtin_fw_huc_g9_desc="HuC Firmware for Gen9"
builtin_fw_huc_g9_files=(
	i915/kbl_huc_ver02_00_1810.bin
)

builtin_fw_x86_aml_ucode_desc="Intel ucode for AML"
builtin_fw_x86_aml_ucode_files=(
	intel-ucode/06-8e-09
	intel-ucode/06-8e-0c
)

builtin_fw_x86_apl_ucode_desc="Intel ucode for APL"
builtin_fw_x86_apl_ucode_files=(
	intel-ucode/06-5c-09
)

builtin_fw_x86_bdw_ucode_desc="Intel ucode for BDW"
builtin_fw_x86_bdw_ucode_files=(
	intel-ucode/06-3d-04
)

builtin_fw_x86_bsw_ucode_desc="Intel ucode for BSW"
builtin_fw_x86_bsw_ucode_files=(
	intel-ucode/06-4c-03
	intel-ucode/06-4c-04
)

builtin_fw_x86_byt_ucode_desc="Intel ucode for BYT"
builtin_fw_x86_byt_ucode_files=(
	intel-ucode/06-37-08
)

builtin_fw_x86_glk_ucode_desc="Intel ucode for GLK"
builtin_fw_x86_glk_ucode_files=(
	intel-ucode/06-7a-01
)

builtin_fw_x86_kbl_ucode_desc="Intel ucode for KBL"
builtin_fw_x86_kbl_ucode_files=(
	intel-ucode/06-8e-09
	intel-ucode/06-8e-0a
)

builtin_fw_x86_skl_ucode_desc="Intel ucode for SKL"
builtin_fw_x86_skl_ucode_files=(
	intel-ucode/06-4e-03
)

builtin_fw_x86_whl_ucode_desc="Intel ucode for WHL"
builtin_fw_x86_whl_ucode_files=(
	intel-ucode/06-8e-0b
	intel-ucode/06-8e-0c
)

extra_fw_config="
CONFIG_EXTRA_FIRMWARE=\"%FW%\"
CONFIG_EXTRA_FIRMWARE_DIR=\"%ROOT%/lib/firmware\"
"

# Add all config and firmware fragments as off by default
IUSE="${IUSE} ${CONFIG_FRAGMENTS[@]} ${FIRMWARE_BINARIES[@]}"
REQUIRED_USE="${REQUIRED_USE}
	factory_netboot_ramfs? ( !recovery_ramfs !factory_shim_ramfs )
	factory_shim_ramfs? ( !recovery_ramfs !factory_netboot_ramfs )
	recovery_ramfs? ( !factory_netboot_ramfs !factory_shim_ramfs )
	factory_netboot_ramfs? ( i2cdev )
	factory_shim_ramfs? ( i2cdev )
	recovery_ramfs? ( i2cdev )
	factory_netboot_ramfs? ( || ( tpm tpm2 ) )
	factory_shim_ramfs? ( || ( tpm tpm2 ) )
	recovery_ramfs? ( || ( tpm tpm2 ) )
"

# If an overlay has eclass overrides, but doesn't actually override this
# eclass, we'll have ECLASSDIR pointing to the active overlay's
# eclass/ dir, but this eclass is still in the main chromiumos tree.  So
# add a check to locate the cros-kernel/ regardless of what's going on.
ECLASSDIR_LOCAL=${BASH_SOURCE[0]%/*}
eclass_dir() {
	local d="${ECLASSDIR}/cros-kernel"
	if [[ ! -d ${d} ]] ; then
		d="${ECLASSDIR_LOCAL}/cros-kernel"
	fi
	echo "${d}"
}

# @FUNCTION: kernelrelease
# @DESCRIPTION:
# Returns the current compiled kernel version.
# Note: Only valid after src_configure has finished running.
kernelrelease() {
	# Try to fastpath figure out the kernel release since calling
	# kmake is slow.  The idea here is that if we happen to be
	# running this function at the end of the install phase then
	# there will be a binary that was created with the kernel
	# version as a suffix.  We can look at that to figure out the
	# version.
	#
	# NOTE: it's safe to always call this function because ${D}
	# isn't something that is kept between incremental builds, IOW
	# it's not like $(cros-workon_get_build_dir).  That means that
	# if ${D}/boot/vmlinuz-* exists it must be the right one.

	local kernel_bins=("${D}"/boot/vmlinuz-*)
	local version

	if [[ ${#kernel_bins[@]} -eq 1 ]]; then
		version="${kernel_bins[0]##${D}/boot/vmlinuz-}"
	fi
	if [[ -z "${version}" || "${version}" == '*' ]]; then
		version="$(kmake -s --no-print-directory kernelrelease)"
	fi

	echo "${version}"
}

# @FUNCTION: cc_option
# @DESCRIPTION:
# Return 0 if ${CC} supports all provided options, 1 otherwise.
# test-flags-CC tests each flag individually and returns the
# supported flags, which is not what we need here.
cc_option() {
	local t="$(test-flags-CC $1)"
	[[ "${t}" == "$1" ]]
}

# @FUNCTION: install_kernel_sources
# @DESCRIPTION:
# Installs the kernel sources into ${D}/usr/src/${P} and fixes symlinks.
# The package must have already installed a directory under ${D}/lib/modules.
install_kernel_sources() {
	local version=$(kernelrelease)
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
	cp -pPR "$(cros-workon_get_build_dir)"/. "${D}/${dest_build_dir}" || die

	# Modify Makefile to use the ROOT environment variable if defined.
	# This path needs to be absolute so that the build directory will
	# still work if copied elsewhere.
	sed -i -e "s@${S}@\$(ROOT)/${dest_source_dir}@" \
		"${D}/${dest_build_dir}/Makefile" || die
}

get_build_cfg() {
	echo "$(cros-workon_get_build_dir)/.config"
}

# Get architecture to be used for
# - "<arch>_defconfig" if there is no splitconfig
# - "chromiumos-<arch>" if CHROMEOS_KERNEL_SPLITCONFIG is not defined
get_build_arch() {
	if [[ "${ARCH}" == "arm"  ||  "${ARCH}" == "arm64" ]]; then
		case "${CHROMEOS_KERNEL_SPLITCONFIG}" in
			*exynos*)
				echo "exynos5"
				;;
			*qualcomm*)
				echo "qualcomm"
				;;
			*rockchip64*)
				echo "rockchip64"
				;;
			*rockchip*)
				echo "rockchip"
				;;
			*tegra*)
				echo "tegra"
				;;
			*)
				echo "${ARCH}"
				;;
		esac
	elif [[ "${ARCH}" == "x86" ]]; then
		case "${CHROMEOS_KERNEL_SPLITCONFIG}" in
			*i386*)
				echo "i386"
				;;
			*x86_64*)
				echo "x86_64"
				;;
			*)
				echo "x86"
				;;
		esac
	elif [[ "${ARCH}" == "amd64" ]]; then
		echo "x86_64"
	elif [[ "${ARCH}" == "mips" ]]; then
		case "${CHROMEOS_KERNEL_SPLITCONFIG}" in
			*pistachio*)
				echo "pistachio"
				;;
			*)
				echo "maltasmvp"
				;;
		esac
	else
		tc-arch-kernel
	fi
}

# @FUNCTION: cros_chkconfig_present
# @USAGE: <option to check config for>
# @DESCRIPTION:
# Returns success of the provided option is present in the build config.
cros_chkconfig_present() {
	local config=$1
	grep -q "^CONFIG_$1=[ym]$" "$(get_build_cfg)"
}

cros-kernel2_pkg_setup() {
	# This is needed for running src_test().  The kernel code will need to
	# be rebuilt with `make check`.  If incremental build were enabled,
	# `make check` would have nothing left to build.
	use test && export CROS_WORKON_INCREMENTAL_BUILD=0
	cros-workon_pkg_setup
}

# @FUNCTION: _cros-kernel2_get_fit_compression
# @USAGE:
# @DESCRIPTION:
# Returns what compression algorithm the kernel uses in the FIT
# image. Currently only applicable for arm64 since on all other
# kernels we use the zImage which is created/compressed by the kernel
# build itself; returns "none" when not applicable.
_cros-kernel2_get_fit_compression() {
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}

	if [[ "${kernel_arch}" != "arm64" ]]; then
		echo none
	elif use fit_compression_kernel_lz4; then
		echo lz4
	elif use fit_compression_kernel_lzma; then
		echo lzma
	else
		echo none
	fi
}

# @FUNCTION: _cros-kernel2_get_fit_kernel_path
# @USAGE:
# @DESCRIPTION:
# Returns the releative path to the (uncompressed) kernel we'll put in the fit
# image.
_cros-kernel2_get_fit_kernel_path() {
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}

	case ${kernel_arch} in
		arm64)
			echo "arch/${kernel_arch}/boot/Image"
			;;
		mips)
			echo "vmlinuz.bin"
			;;
		*)
			echo "arch/${kernel_arch}/boot/zImage"
			;;
	esac
}

# @FUNCTION: _cros-kernel2_get_fit_compressed_kernel_path
# @USAGE:
# @DESCRIPTION:
# Returns the releative path to the compressed kernel we'll put in the fit
# image; if we're using a compression of "none" this will just return the
# path of the uncompressed kernel.
_cros-kernel2_get_compressed_path() {
	local uncompressed_path="$(_cros-kernel2_get_fit_kernel_path)"
	local compression="$(_cros-kernel2_get_fit_compression)"

	if [[ "${compression}" == "none" ]]; then
		echo "${uncompressed_path}"
	else
		echo "${uncompressed_path}.${compression}"
	fi
}

# @FUNCTION: _cros-kernel2_compress_fit_kernel
# @USAGE: <kernel_dir>
# @DESCRIPTION:
# Compresses the kernel with the algorithm selected by current USE flags. If
# no compression algorithm this does nothing.
_cros-kernel2_compress_fit_kernel() {
	local kernel_dir=${1}
	local kernel_path="${kernel_dir}/$(_cros-kernel2_get_fit_kernel_path)"
	local compr_path="${kernel_dir}/$(_cros-kernel2_get_compressed_path)"
	local compression="$(_cros-kernel2_get_fit_compression)"

	case "${compression}" in
		lz4)
			lz4 -20 -z -f "${kernel_path}" "${compr_path}" || die
			;;
		lzma)
			lzma -9 -z -f -k "${kernel_path}" || die
			;;
	esac
}

# @FUNCTION: _cros-kernel2_get_compat
# @USAGE: <dtb file>
# @DESCRIPTION:
# Returns the list of compatible strings extracted from a given .dtb file, in
# the format required to re-insert it in a new property of an its-script.
_cros-kernel2_get_compat() {
	local dtb="$1"
	local result=""
	local s

	for s in $(fdtget "${dtb}" / compatible); do
		result+="\"${s}\","
	done

	printf "${result%,}"
}

# @FUNCTION: _cros-kernel2_emit_its_script
# @USAGE: <output file> <kernel_dir> <device trees>
# @DESCRIPTION:
# Emits the its script used to build the u-boot fitImage kernel binary
# that contains the kernel as well as device trees used when booting
# it.
_cros-kernel2_emit_its_script() {
	local compat=()
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
	local fit_compression_fdt="none"
	local fit_compression_kernel
	local kernel_bin_path
	local iter=1
	local its_out=${1}
	shift
	local kernel_dir=${1}
	shift

	fit_compression_kernel="$(_cros-kernel2_get_fit_compression)"
	kernel_bin_path="${kernel_dir}/$(_cros-kernel2_get_compressed_path)"

	cat > "${its_out}" <<-EOF || die
	/dts-v1/;

	/ {
		description = "Chrome OS kernel image with one or more FDT blobs";
		#address-cells = <1>;

		images {
			kernel@1 {
				data = /incbin/("${kernel_bin_path}");
				type = "kernel_noload";
				arch = "${kernel_arch}";
				os = "linux";
				compression = "${fit_compression_kernel}";
				load = <0>;
				entry = <0>;
			};
	EOF

	local dtb
	for dtb in "$@" ; do
		compat[${iter}]=$(_cros-kernel2_get_compat "${dtb}")
		if use dt_compression; then
			# Compress all DTBs in parallel (only needed after this function).
			lz4 -20 -z -f "${dtb}" "${dtb}.lz4" || die &
			dtb="${dtb}.lz4"
			fit_compression_fdt="lz4"
		fi
		cat >> "${its_out}" <<-EOF || die
			fdt@${iter} {
				description = "$(basename ${dtb})";
				data = /incbin/("${dtb}");
				type = "flat_dt";
				arch = "${kernel_arch}";
				compression = "${fit_compression_fdt}";
				hash@1 {
					algo = "sha1";
				};
			};
		EOF
		((++iter))
	done

	cat <<-EOF >>"${its_out}"
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
				compatible = ${compat[${i}]};
			};
		EOF
	done

	echo "	};" >> "${its_out}"
	echo "};" >> "${its_out}"

	# Wait for DTB compression to finish.
	wait
}

kmake() {
	local wifi_version
	local v
	for v in ${WIRELESS_VERSIONS[@]}; do
		if use wireless${v/.} ; then
			[ -n "${wifi_version}" ] &&
				die "Wireless ${v} AND ${wifi_version} both set"
			wifi_version=${v}
			set -- "$@" WIFIVERSION="-${v}"
		fi
	done

	# Allow override of kernel arch.
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}

	# Support 64bit kernels w/32bit userlands.
	local cross=${CHOST}
	case ${ARCH}:${kernel_arch} in
		x86:x86_64)
			cross="x86_64-cros-linux-gnu"
			;;
		arm:arm64)
			cross="aarch64-cros-linux-gnu"
			;;
	esac

	if [[ "${CHOST}" != "${cross}" ]]; then
		unset CC CXX LD STRIP OBJCOPY
	fi

	tc-export_build_env BUILD_{CC,CXX}
	CHOST=${cross} tc-export CC CXX LD STRIP OBJCOPY
	if use clang; then
		CHOST=${cross} clang-setup-env
	fi
	local binutils_path=$(LD=${cross}-ld get_binutils_path_ld)
	# Use ld.lld instead of ${cross}-ld.lld, ${cross}-ld.lld has userspace
	# specific options. Linux kernel already specifies the type by "-m <type>".
	# It also matches upstream (https://github.com/ClangBuiltLinux) and
	# Android usage.
	local linker=$(usex lld "ld.lld" "${binutils_path}/ld")

	set -- \
		LD="${linker}" \
		CC="${CC} -B${binutils_path}" \
		CXX="${CXX} -B${binutils_path}" \
		HOSTCC="${BUILD_CC}" \
		HOSTCXX="${BUILD_CXX}" \
		"$@"

	local kcflags="${KCFLAGS}"
	local afdo_filename afdo_option
	if use clang; then
		afdo_filename="${WORKDIR}/${AFDO_GCOV_COMPBINARY}"
		afdo_option="profile-sample-use"
	else
		afdo_filename="${WORKDIR}/${AFDO_GCOV}"
		afdo_option="auto-profile"
	fi
	use kernel_afdo && kcflags+=" -f${afdo_option}=${afdo_filename}"

	local indirect_branch_options_v1=(
		"-mindirect-branch=thunk"
		"-mindirect-branch-loop=pause"
		"-fno-jump-tables"
	)
	local indirect_branch_options_v2=(
		"-mindirect-branch=thunk"
		"-mindirect-branch-register"
	)

	# Indirect branch options only available for Intel GCC and clang.
	if use x86 || use amd64; then
		# The kernel will set required compiler options if it supports
		# the RETPOLINE configuration option and it is enabled.
		# Otherwise set supported compiler options here to get a basic
		# level of protection.
		if ! cros_chkconfig_present RETPOLINE; then
			if use clang; then
				kcflags+=" $(test-flags-CC -mretpoline)"
			else
				if cc_option "${indirect_branch_options_v1[*]}"; then
					kcflags+=" ${indirect_branch_options_v1[*]}"
				elif cc_option "${indirect_branch_options_v2[*]}"; then
					kcflags+=" ${indirect_branch_options_v2[*]}"
				fi
			fi
		fi
	fi

	# LLVM needs this to parse perf.data.
	# See AutoFDO README for details: https://github.com/google/autofdo
	use clang && kcflags+=" -fdebug-info-for-profiling "

	# The kernel doesn't use CFLAGS and doesn't expect it to be passed
	# in.  Let's be explicit that it won't do anything by unsetting CFLAGS.
	#
	# In general the kernel manages its own tools flags and doesn't expect
	# someone external to pass flags in unless those flags have been
	# very specifically tailored to interact well with the kernel Makefiles.
	# In that case we pass in flags with KCFLAGS which is documented to be
	# not a full set of flags but as "additional" flags. In general the
	# kernel Makefiles carefully adjust their flags in various
	# sub-directories to get the needed result.  The kernel has CONFIG_
	# options for adjusting compiler flags and self-adjusts itself
	# depending on whether it detects clang or not.
	#
	# In the same spirit, let's also unset LDFLAGS.  While (in some cases)
	# the kernel will build upon LDFLAGS passed in from the environment it
	# makes sense to just let the kernel be like we do for the rest of the
	# flags.
	unset CFLAGS
	unset LDFLAGS

	ARCH=${kernel_arch} \
		CROSS_COMPILE="${cross}-" \
		KCFLAGS="${kcflags}" \
		emake \
		O="$(cros-workon_get_build_dir)" \
		"$@"
}

cros-kernel2_src_unpack() {
	# Force in-tree builds if private patches may have to be applied.
	if [[ "${PV}" != "9999" ]] || use apply_patches; then
		CROS_WORKON_OUTOFTREE_BUILD=0
	fi

	cros-workon_src_unpack
	if use kernel_afdo && [[ -z "${AFDO_VERSION}" ]]; then
		eerror "AFDO_PROFILE_VERSION is required in .ebuild by kernel_afdo."
		die
	fi

	pushd "${WORKDIR}" > /dev/null
	if use kernel_afdo; then
		unpack "${AFDO_GCOV}.xz"

		# Compressed binary profiles are lazily loaded, so they save a
		# meaningful amount of CPU and memory per clang invocation. They're
		# only available with clang.
		if use clang; then
			llvm-profdata merge \
				-sample \
				-compbinary \
				-output="${AFDO_GCOV_COMPBINARY}" \
				"${AFDO_GCOV}" || die
		fi
	fi
	popd > /dev/null
}

cros-kernel2_src_prepare() {
	if [[ "${PV}" != "9999" ]] || use apply_patches; then
		apply_private_patches
	fi
	use clang || cros_use_gcc
	cros-workon_src_prepare
}

cros-kernel2_src_configure() {
	# The kernel controls its own optimization settings, so this would be a nop
	# if we were to run it. Leave it here anyway as a grep-friendly marker.
	# cros_optimize_package_for_speed

	# Use a single or split kernel config as specified in the board or variant
	# make.conf overlay. Default to the arch specific split config if an
	# overlay or variant does not set either CHROMEOS_KERNEL_CONFIG or
	# CHROMEOS_KERNEL_SPLITCONFIG. CHROMEOS_KERNEL_CONFIG is set relative
	# to the root of the kernel source tree.
	local config
	local cfgarch="$(get_build_arch)"
	local build_cfg="$(get_build_cfg)"

	if use buildtest; then
		local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
		kmake allmodconfig
		case ${kernel_arch} in
			arm)
				# Big endian builds fail with endianness mismatch errors.
				# See crbug.com/772028 for details.
				sed -i -e 's/CONFIG_CPU_BIG_ENDIAN=y/# CONFIG_CPU_BIG_ENDIAN is not set/' "${build_cfg}"
				;;
		esac
		kmake olddefconfig
		return 0
	fi

	if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
		case ${CHROMEOS_KERNEL_CONFIG} in
			/*)
				config="${CHROMEOS_KERNEL_CONFIG}"
				;;
			*)
				config="${S}/${CHROMEOS_KERNEL_CONFIG}"
				;;
		esac
	else
		config=${CHROMEOS_KERNEL_SPLITCONFIG:-"chromiumos-${cfgarch}"}
	fi

	elog "Using kernel config: ${config}"

	if [ -n "${CHROMEOS_KERNEL_CONFIG}" ]; then
		cp -f "${config}" "${build_cfg}" || die
	else
		if [ -e chromeos/scripts/prepareconfig ] ; then
			chromeos/scripts/prepareconfig ${config} \
				"${build_cfg}" || die
		else
			config="$(eclass_dir)/${cfgarch}_defconfig"
			ewarn "Can't prepareconfig, falling back to default " \
				"${config}"
			cp "${config}" "${build_cfg}" || die
		fi
	fi

	local fragment
	for fragment in ${CONFIG_FRAGMENTS[@]}; do
		local config="${fragment}_config"
		local status

		if [[ ${!config+set} != "set" ]]; then
			die "'${fragment}' listed in CONFIG_FRAGMENTS, but ${config} is not set up"
		fi

		if use ${fragment}; then
			status="enabling"
		else
			config="${fragment}_config_disable"
			status="disabling"
			if [[ -z "${!config}" ]]; then
				continue
			fi
		fi

		local msg="${fragment}_desc"
		elog "   - ${status} ${!msg} config"
		local warning="${fragment}_warning"
		local warning_msg="${!warning}"
		if [[ -n "${warning_msg}" ]] ; then
			ewarn "${warning_msg}"
		fi

		echo "${!config}" | \
			sed -e "s|%ROOT%|${SYSROOT}|g" \
			>> "${build_cfg}" || die
	done

	local -a builtin_fw
	for fragment in "${FIRMWARE_BINARIES[@]}"; do
		local files="${fragment}_files[@]"

		if [[ ${!files+set} != "set" ]]; then
			die "'${fragment}' listed in FIRMWARE_BINARIES, but ${files} is not set up"
		fi

		if use ${fragment}; then
			local msg="${fragment}_desc"
			elog "   - Embedding ${!msg} firmware"
			builtin_fw+=( "${!files}" )
		fi
	done

	if [[ ${#builtin_fw[@]} -gt 0 ]]; then
		echo "${extra_fw_config}" | \
			sed -e "s|%ROOT%|${SYSROOT}|g" -e "s|%FW%|${builtin_fw[*]}|g" \
			>> "${build_cfg}" || die
	fi

	# If the old config is unchanged restore it.  This allows us to keep
	# the old timestamp which will avoid regenerating stuff that hasn't
	# actually changed.  Note that we compare against the non-normalized
	# config to avoid an extra call to "kmake olddefconfig" in the common
	# case.
	#
	# If the old config changed, we'll normalize the new one and stash
	# both the non-normalized and normalized versions for next time.

	local old_config="$(cros-workon_get_build_dir)/cros-old-config"
	local old_defconfig="$(cros-workon_get_build_dir)/cros-old-defconfig"

	if [[ -e "${old_config}" && -e "${old_defconfig}" ]] && \
		cmp -s "${build_cfg}" "${old_config}"; then
		cp -a "${old_defconfig}" "${build_cfg}" || die
	else
		cp -a "${build_cfg}" "${old_config}" || die

		# Use default for options not explicitly set in splitconfig.
		kmake olddefconfig

		cp -a "${build_cfg}" "${old_defconfig}" || die
	fi

	# Create .scmversion file so that kernel release version
	# doesn't include git hash for cros worked on builds.
	if [[ "${PV}" == "9999" ]]; then
		touch "$(cros-workon_get_build_dir)/.scmversion"
	fi
}

# @FUNCTION: get_dtb_name
# @USAGE: <dtb_dir>
# @DESCRIPTION:
# Get the name(s) of the device tree binary file(s) to include.

get_dtb_name() {
	local dtb_dir=${1}
	# Add sort to stabilize the dtb ordering.
	find ${dtb_dir} -name "*.dtb" | LC_COLLATE=C sort
}

gen_compilation_database() {
	local build_dir="$(cros-workon_get_build_dir)"
	local src_dir="${build_dir}/source"
	local db_chroot="${build_dir}/compile_commands_chroot.json"

	"${src_dir}/scripts/gen_compile_commands.py" -d "${build_dir}" \
		-o "${db_chroot}"|| die

	# Make relative include paths absolute.
	sed -i -e "s:-I\./:-I${build_dir}/:g" "${db_chroot}" || die

	local ext_chroot_path="${EXTERNAL_TRUNK_PATH}/chroot"
	local in_chroot_path="$(readlink -f "${src_dir}")"
	local ext_src_path="${EXTERNAL_TRUNK_PATH}/${in_chroot_path#/mnt/host/source/}"

	# Generate non-chroot version of the DB with the following
	# changes:
	#
	# 1. translate file and directory paths
	# 2. call clang directly instead of using CrOS wrappers
	# 3. use standard clang target triples
	# 4. remove a few compiler options that might not be available
	#    in the potentially older clang version outside the chroot
	#
	sed -E -e "s:/mnt/host/source/:${EXTERNAL_TRUNK_PATH}/:g" \
		-e "s:\"${src_dir}:\"${ext_src_path}:g" \
		-e "s:-I/build/:-I${ext_chroot_path}/build/:g" \
		-e "s:\"/build/:\"${ext_chroot_path}/build/:g" \
		-e "s:-isystem /:-isystem ${ext_chroot_path}/:g" \
		\
		-e "s:[a-z0-9_]+-(cros|pc)-linux-gnu([a-z]*)?-clang:clang:g" \
		\
		-e "s:([a-z0-9_]+)-cros-linux-gnu:\1-linux-gnu:g" \
		\
		-e "s:-fdebug-info-for-profiling::g" \
		-e "s:-mretpoline::g" \
		-e "s:-mretpoline-external-thunk::g" \
		-e "s:-mfentry::g" \
		\
		"${db_chroot}" \
		> "${build_dir}/compile_commands_no_chroot.json" || or die

	echo \
"compile_commands_*.json are compilation databases for the Linux kernel. The
files can be used by tools that support the commonly used JSON compilation
database format.

To use the compilation database with an IDE or other tools outside of the
chroot create a symlink named 'compile_commands.json' in the kernel source
directory (outside of the chroot) to compile_commands_no_chroot.json." \
		> "${build_dir}/compile_commands.txt" || die
}

_cros-kernel2_compile() {
	local build_targets=()  # use make default target
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
	case ${kernel_arch} in
		arm)
			build_targets=(
				$(usex device_tree 'zImage dtbs' uImage)
				$(usex boot_dts_device_tree dtbs '')
				$(cros_chkconfig_present MODULES && echo "modules")
				$(use kgdb &&
					sed -nE 's/^(scripts_gdb):.*$/\1/p' Makefile)
			)
			;;
		arm64)
			build_targets=(
				Image dtbs
				$(cros_chkconfig_present MODULES && echo "modules")
				$(use kgdb &&
					sed -nE 's/^(scripts_gdb):.*$/\1/p' Makefile)
			)
			;;
		mips)
			build_targets=(
				vmlinuz.bin
				$(usex device_tree 'dtbs' '')
				$(cros_chkconfig_present MODULES && echo "modules")
				$(use kgdb &&
					sed -nE 's/^(scripts_gdb):.*$/\1/p' Makefile)
			)
			;;
	esac

	local src_dir="$(cros-workon_get_build_dir)/source"
	SMATCH_ERROR_FILE="${src_dir}/chromeos/check/smatch_errors.log"

	# If a .dts file is deleted from the source code it won't disappear
	# from the output in the next incremental build.  Nuke all dtbs so we
	# don't include stale files.  We use 'find' to handle old and new
	# locations (see comments in install below).
	find "$(cros-workon_get_build_dir)/arch" -name '*.dtb' -delete

	if use test && [[ -e "${SMATCH_ERROR_FILE}" ]]; then
		local make_check_cmd="smatch -p=kernel"
		local test_options=(
			CHECK="${make_check_cmd}"
			C=1
		)
		SMATCH_LOG_FILE="$(cros-workon_get_build_dir)/make.log"

		# The path names in the log file are build-dependent.  Strip out
		# the part of the path before "kernel/files" and retains what
		# comes after it: the file, line number, and error message.
		kmake -k ${build_targets[@]} "${test_options[@]}" |& \
			tee "${SMATCH_LOG_FILE}"
	else
		kmake -k ${build_targets[@]}
	fi

	if use compilation_database || ( use test && use clang ); then
		gen_compilation_database
	fi
}

cros-kernel2_src_compile() {
	local old_config="$(cros-workon_get_build_dir)/cros-old-config"
	local old_defconfig="$(cros-workon_get_build_dir)/cros-old-defconfig"
	local build_cfg="$(get_build_cfg)"

	# Some users of cros-kernel2 touch the config after
	# cros-kernel2_src_configure finishes.  Detect that and remove
	# the old configs we were saving to speed up the next
	# incremental build.  These users of cros-kernel2 will be
	# slower but they will still work OK.
	if ! cmp -s "${build_cfg}" "${old_defconfig}"; then
		ewarn "Slowing build speed because ebuild touched config."
		rm -f "${old_config}" "${old_defconfig}" || die
	fi

	_cros-kernel2_compile

	# If Kconfig files have changed since we last did a compile then the
	# .config file that we passed in the kernel might not have been in
	# perfect form.  In general we only generate / make defconfig in
	# cros-kernel2_src_configure() if we see that our config changed (we
	# don't detect Kconfig changes).
	#
	# It's _probably_ fine that we just built the kernel like this because
	# the kernel detects this case, falls into a slow path, and then
	# noisily does a defconfig.  However, there is a very small chance that
	# the results here will be unexpected.  Specifically if you're jumping
	# between very different kernels and you're using an underspecified
	# config (like the fallback config), it's possible the results will be
	# wrong.  AKA if you start with the raw config, then make a defconfig
	# with kernel A, then use that defconfig w/ kernel B to generate a new
	# defconfig, you could end up with a different result than if you
	# sent the raw config straight to kernel B.
	#
	# Let's be paranoid and keep things safe.  We'll detect if we got
	# it wrong and in that case compile the kernel a 2nd time.

	# Check if defconfig is different after the kernel build finished.
	if [[ -e "${old_defconfig}" ]] && \
		! cmp -s "${build_cfg}" "${old_defconfig}"; then
		# We'll stash what the kernel came up with as a defconfig.
		cp -a "${build_cfg}" "${old_defconfig}" || die

		# Re-create a new defconfig from the stashed raw config.
		cp -a "${old_config}" "${build_cfg}" || die
		kmake olddefconfig

		# If the newly generated defconfig is different from what
		# the kernel came up with then do a recompile.
		if ! cmp -s "${build_cfg}" "${old_defconfig}"; then
			ewarn "Detected Kconfig change; redo with olddefconfig"

			cp -a "${build_cfg}" "${old_defconfig}" || die
			_cros-kernel2_compile
		fi
	fi
}

cros-kernel2_src_test() {
	if use buildtest ; then
		ewarn "Skipping unit tests for buildtest"
		return 0
	fi

	[[ -e ${SMATCH_ERROR_FILE} ]] || \
		die "smatch whitelist file ${SMATCH_ERROR_FILE} not found!"
	[[ -e ${SMATCH_LOG_FILE} ]] || \
		die "Log file from src_compile() ${SMATCH_LOG_FILE} not found!"

	local prefix="$(realpath "${S}")/"
	grep -w error: "${SMATCH_LOG_FILE}" | grep -o "${prefix}.*" \
		| sed s:"${prefix}"::g > "${SMATCH_LOG_FILE}.errors"
	local num_errors=$(wc -l < "${SMATCH_LOG_FILE}.errors")
	local num_warnings=$(egrep -wc "warn:|warning:" "${SMATCH_LOG_FILE}")
	einfo "smatch found ${num_errors} errors and ${num_warnings} warnings."

	# Create a version of the error database that doesn't have line numbers,
	# since line numbers will shift as code is added or removed.
	local build_dir="$(cros-workon_get_build_dir)"
	local no_line_numbers_file="${build_dir}/no_line_numbers.log"
	sed -r -e "s/(:[0-9]+){1,2}//" \
			-e "s/\(see line [0-9]+\)//" \
			"${SMATCH_ERROR_FILE}" > "${no_line_numbers_file}"

	# For every smatch error that came up during the build, check if it is
	# in the error database file.
	local num_unknown_errors=0
	local line=""
	while read line; do
		local no_line_num=$(echo "${line}" | \
			sed -r -e "s/(:[0-9]+){1,2}//" \
					-e "s/\(see line [0-9]+\)//")
		if ! fgrep -q "${no_line_num}" "${no_line_numbers_file}"; then
			eerror "Non-whitelisted error found: \"${line}\""
			: $(( ++num_unknown_errors ))
		fi
	done < "${SMATCH_LOG_FILE}.errors"

	[[ ${num_unknown_errors} -eq 0 ]] || \
		die "smatch found ${num_unknown_errors} unknown errors."
}

cros-kernel2_src_install() {
	if use firmware_install; then
		die "The firmware_install USE flag is dead."
	fi

	if use buildtest ; then
		ewarn "Skipping install for buildtest"
		return 0
	fi

	dodir /boot
	kmake INSTALL_PATH="${D}/boot" install

	if use device_tree; then
		_cros-kernel2_compress_fit_kernel \
			"$(cros-workon_get_build_dir)" &
	fi

	if cros_chkconfig_present MODULES; then
		kmake INSTALL_MOD_PATH="${D}" INSTALL_MOD_STRIP="magic" \
			STRIP="$(eclass_dir)/strip_splitdebug" \
			modules_install
	fi

	local version=$(kernelrelease)
	local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
	local kernel_bin="${D}/boot/vmlinuz-${version}"

	# We might have compressed in background; wait for it now.
	wait

	if use arm || use arm64 || use mips; then
		local kernel_dir="$(cros-workon_get_build_dir)"
		local boot_dir="${kernel_dir}/arch/${kernel_arch}/boot"
		local zimage_bin="${D}/boot/zImage-${version}"
		local image_bin="${D}/boot/Image-${version}"
		local dtb_dir="${boot_dir}"

		# Newer kernels (after linux-next 12/3/12) put dtbs in the dts
		# dir.  Use that if we we find no dtbs directly in boot_dir.
		# Note that we try boot_dir first since the newer kernel will
		# actually rm ${boot_dir}/*.dtb so we'll have no stale files.
		if ! ls "${dtb_dir}"/*.dtb &> /dev/null; then
			dtb_dir="${boot_dir}/dts"
		fi

		if use device_tree; then
			local its_script="${kernel_dir}/its_script"
			_cros-kernel2_emit_its_script "${its_script}" \
				"${kernel_dir}" $(get_dtb_name "${dtb_dir}")
			mkimage -D "-I dts -O dtb -p 2048" -f "${its_script}" \
				"${kernel_bin}" || die
		elif [[ "${kernel_arch}" == "arm" ]]; then
			cp "${boot_dir}/uImage" "${kernel_bin}" || die
			if use boot_dts_device_tree; then
				# For boards where the device tree .dtb file is stored
				# under /boot/dts, loaded into memory, and then
				# passed on the 'bootm' command line, make sure they're
				# all installed.
				#
				# We install more .dtb files than we need, but it's
				# less work than a hard-coded list that gets out of
				# date.
				#
				# TODO(jrbarnette):  Really, this should use a
				# FIT image, same as other boards.
				insinto /boot/dts
				doins "${dtb_dir}"/*.dtb
			fi
		fi
		case ${kernel_arch} in
			arm)
				cp -a "${boot_dir}/zImage" "${zimage_bin}" || die
				;;
			arm64)
				cp -a "${boot_dir}/Image" "${image_bin}" || die
				;;
		esac
	fi
	if use arm || use arm64 || use mips; then
		# TODO(vbendeb): remove the below .uimg link creation code
		# after the build scripts have been modified to use the base
		# image name.
		pushd "$(dirname "${kernel_bin}")" > /dev/null
		ln -sf $(basename "${kernel_bin}") vmlinux.uimg || die
		case ${kernel_arch} in
			arm)
				ln -sf $(basename "${zimage_bin}") zImage || die
				;;
		esac
		popd > /dev/null
	fi
	if [ ! -e "${D}/boot/vmlinuz" ]; then
		ln -sf "vmlinuz-${version}" "${D}/boot/vmlinuz" || die
	fi

	# Check the size of kernel image and issue warning when image size is near
	# the limit. For netboot initramfs, we don't care about kernel
	# size limit as the image is downloaded over network.
	local kernel_image_size=$(stat -c '%s' -L "${D}"/boot/vmlinuz)
	einfo "Kernel image size is ${kernel_image_size} bytes."
	if use factory_netboot_ramfs; then
		# No need to check kernel image size.
		true
	else
		if version_is_at_least 3.18 ${version} ; then
			kern_max=32
			kern_warn=12
		elif version_is_at_least 3.10 ${version} ; then
			kern_max=16
			kern_warn=12
		else
			kern_max=8
			kern_warn=7
		fi

		if [[ ${kernel_image_size} -gt $((kern_max * 1024 * 1024)) ]]; then
			die "Kernel image is larger than ${kern_max} MB."
		elif [[ ${kernel_image_size} -gt $((kern_warn * 1024 * 1024)) ]]; then
			ewarn "Kernel image is larger than ${kern_warn} MB. Limit is ${kern_max} MB."
		fi
	fi

	# Install uncompressed kernel for debugging purposes.
	insinto /usr/lib/debug/boot
	doins "$(cros-workon_get_build_dir)/vmlinux"
	if use kgdb && [[ -d "$(cros-workon_get_build_dir)/scripts/gdb" ]]; then
		cp "$(cros-workon_get_build_dir)/vmlinux-gdb.py" "${D}"/usr/lib/debug/boot/ || die
		mkdir "${D}"/usr/lib/debug/boot/scripts || die
		rsync -rKL \
			--include='*/' --include='*.py' --exclude='*' \
			"$(cros-workon_get_build_dir)/scripts/gdb/" "${D}"/usr/lib/debug/boot/scripts/gdb || die
	fi

	# Also install the vdso shared ELFs for crash reporting.
	# We use slightly funky filenames so as to better integrate with
	# debugging processes (crash reporter/gdb/etc...).  The basename
	# will be the SONAME (what the runtime process sees), but since
	# that is not unique among all inputs, we also install into a dir
	# with the original filename.  e.g. we will install:
	#  /lib/modules/3.8.11/vdso/vdso32-syscall.so/linux-gate.so
	if use x86 || use amd64; then
		local vdso_dir d f soname
		vdso_dir="$(cros-workon_get_build_dir)/arch/x86/vdso"
		if [[ ! -d ${vdso_dir} ]]; then
			# Use new path with newer (>= v4.2-rc1) kernels
			vdso_dir="$(cros-workon_get_build_dir)/arch/x86/entry/vdso"
		fi
		[[ -d ${vdso_dir} ]] || die "could not find x86 vDSO dir"

		# Use the debug versions (.so.dbg) so portage can run splitdebug on them.
		for f in "${vdso_dir}"/vdso*.so.dbg; do
			d="/lib/modules/${version}/vdso/${f##*/}"

			exeinto "${d}"
			newexe "${f}" "linux-gate.so"

			soname=$(scanelf -qF'%S#f' "${f}")
			dosym "linux-gate.so" "${d}/${soname}"
		done
	fi

	if use kernel_sources; then
		install_kernel_sources
	else
		dosym "$(cros-workon_get_build_dir)" "/usr/src/linux"
	fi

	if use compilation_database || ( use test && use clang ); then
		insinto /build/kernel
		einfo "Installing kernel compilation databases.
To use the compilation database with an IDE or other tools outside of the
chroot create a symlink named 'compile_commands.json' in the kernel source
directory (outside of the chroot) to compile_commands_no_chroot.json."
		doins "$(cros-workon_get_build_dir)"/compile_commands_*.json
		doins "$(cros-workon_get_build_dir)"/compile_commands.txt
	fi
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install
